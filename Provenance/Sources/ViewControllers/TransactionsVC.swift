import Cocoa
import Alamofire
import SwiftDate

final class TransactionsVC: NSViewController {
  private typealias DataSource = NSCollectionViewDiffableDataSource<SortedTransactionModel, TransactionViewModel>

  private typealias Snapshot = NSDiffableDataSourceSnapshot<SortedTransactionModel, TransactionViewModel>

  private lazy var categorySegmentedControl: NSSegmentedControl = .categories(filter: categoryFilter, menu: categoryMenu)

  private lazy var categoryMenu: NSMenu = .categoryMenu(self, filter: categoryFilter, action: #selector(categoryAction(_:)))

  private lazy var categoryMenuFormRepresentation: NSMenuItem = .categoryMenuFormRepresentation(category: categoryFilter, submenu: categoryMenu)

  private lazy var settledOnlyMenuFormRepresentation: NSMenuItem = .settledOnlyMenuFormRepresentation(self,
                                                                                                      filter: settledOnlyFilter,
                                                                                                      action: #selector(settledOnlyAction))

  private lazy var dataSource = makeDataSource()

  private lazy var toolbar = NSToolbar(self, identifier: .transactions)

  private lazy var categoryToolbarItem = NSToolbarItem.categories(segmentedControl: categorySegmentedControl,
                                                                  menuFormRepresentation: categoryMenuFormRepresentation)

  private lazy var settledOnlyToolbarItem = NSToolbarItem.settledOnlyButton(self,
                                                                            action: #selector(settledOnlyAction),
                                                                            menuFormRepresentation: settledOnlyMenuFormRepresentation)

  private lazy var searchField = NSSearchField(self, type: .transactions)

  private lazy var categoryFilter: TransactionCategory = UserDefaults.provenance.appSelectedCategory {
    didSet {
      let previousItem = categoryMenu.item(withTitle: oldValue.description)
      let currentItem = categoryMenu.item(withTitle: categoryFilter.description)

      if UserDefaults.provenance.selectedCategory != categoryFilter.rawValue {
        UserDefaults.provenance.selectedCategory = categoryFilter.rawValue
      }
      if previousItem?.state != .off {
        previousItem?.state = .off
      }
      if currentItem?.state != .on {
        currentItem?.state = .on
      }
      if (oldValue == .all && categoryFilter != .all) || (oldValue != .all && categoryFilter == .all) {
        let image: NSImage = categoryFilter == .all ? .trayFull : .trayFullFill
        categorySegmentedControl.setImage(image, forSegment: 0)
        categorySegmentedControl.setSelected(categoryFilter == .all ? false : true, forSegment: 0)
        categoryToolbarItem.image = image
        categoryMenuFormRepresentation.state = categoryFilter == .all ? .off : .on
      }
      filterUpdates()
    }
  }

  private lazy var settledOnlyFilter: Bool = UserDefaults.provenance.settledOnly {
    didSet {
      if UserDefaults.provenance.settledOnly != settledOnlyFilter {
        UserDefaults.provenance.settledOnly = settledOnlyFilter
      }
      settledOnlyToolbarItem.image = settledOnlyFilter ? .checkmarkCircleFill.withSymbolConfiguration(.small) : .checkmarkCircle.withSymbolConfiguration(.small)
      toolbar.selectedItemIdentifier = settledOnlyFilter ? .settledOnly : nil
      filterUpdates()
    }
  }

  private var apiKeyObserver: NSKeyValueObservation?

  private var dateStyleObserver: NSKeyValueObservation?

  private var settledOnlyObserver: NSKeyValueObservation?

  private var noTransactions: Bool = false

  private var transactionsError = String()

  private var transactions = [TransactionResource]() {
    didSet {
      transactionsUpdates()
    }
  }

  private var filteredTransactions: [TransactionResource] {
    return preFilteredTransactions.filtered(searchField: searchField)
  }

  private var preFilteredTransactions: [TransactionResource] {
    return transactions.filter { (transaction) in
      return (!settledOnlyFilter || transaction.attributes.status.isSettled) &&
      (categoryFilter == .all || categoryFilter.rawValue == transaction.relationships.category.data?.id)
    }
  }

  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(.transactionItem, forItemWithIdentifier: .transactionItem)
      collectionView.register(.dateSupplementaryView,
                              forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader,
                              withIdentifier: .dateSupplementaryView)
      collectionView.collectionViewLayout = .listPinnedHeaders
      collectionView.backgroundViewScrollsWithContent = true
    }
  }

  override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: "Transactions", bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureObservers()
    applySnapshot(animate: false)
  }

  override func viewWillAppear() {
    super.viewWillAppear()
    fetchingTasks()
    configureWindow()
    guard let appDelegate = NSApp.delegate as? AppDelegate else { return }
    appDelegate.refreshMenuItem.title = "Refresh Transactions"
    appDelegate.refreshMenuItem.target = self
    appDelegate.refreshMenuItem.action = #selector(refreshTransactions)
  }

  @objc
  private func refreshTransactions() {
    fetchTransactions()
  }

  private func configureWindow() {
    AppDelegate.windowController?.window?.toolbar = toolbar
    AppDelegate.windowController?.window?.title = "Transactions"
    toolbar.selectedItemIdentifier = settledOnlyFilter ? .settledOnly : nil
  }

  private func configureObservers() {
    apiKeyObserver = UserDefaults.provenance.observe(\.apiKey, options: .new) { [weak self] (_, _) in
      self?.fetchingTasks()
    }
    dateStyleObserver = UserDefaults.provenance.observe(\.dateStyle, options: .new) { [weak self] (_, _) in
      self?.applySnapshot()
    }
    settledOnlyObserver = UserDefaults.provenance.observe(\.settledOnly, options: .new) { [weak self] (_, change) in
      guard let value = change.newValue else { return }
      self?.settledOnlyFilter = value
    }
  }

  private func removeObservers() {
    apiKeyObserver?.invalidate()
    apiKeyObserver = nil
    dateStyleObserver?.invalidate()
    dateStyleObserver = nil
    settledOnlyObserver?.invalidate()
    settledOnlyObserver = nil
  }

  private func transactionsUpdates() {
    noTransactions = transactions.isEmpty
    applySnapshot()
    searchField.placeholderString = preFilteredTransactions.searchFieldPlaceholder
  }

  private func filterUpdates() {
    searchField.placeholderString = preFilteredTransactions.searchFieldPlaceholder
    applySnapshot()
  }

  private func fetchingTasks() {
    fetchTransactions()
  }

  private func makeDataSource() -> DataSource {
    return DataSource(
      collectionView: collectionView,
      itemProvider: { (collectionView, indexPath, transaction) in
        guard let item = collectionView.makeItem(withIdentifier: .transactionItem, for: indexPath) as? TransactionItem else { fatalError() }
        item.transaction = transaction
        return item
      },
      supplementaryViewProvider: { (collectionView, kind, indexPath) in
        guard let view = collectionView.makeSupplementaryView(ofKind: kind, withIdentifier: .dateSupplementaryView, for: indexPath) as? DateSupplementaryView else { fatalError() }
        view.label.stringValue = self.filteredTransactions.sortedTransactionModels[indexPath.section].id.toString(.date(.medium))
        return view
      }
    )
  }

  private func applySnapshot(animate: Bool = true) {
    var snapshot = Snapshot()

    snapshot.appendSections(filteredTransactions.sortedTransactionModels)
    filteredTransactions.sortedTransactionModels.forEach { snapshot.appendItems($0.transactions, toSection: $0) }

    if snapshot.itemIdentifiers.isEmpty && transactionsError.isEmpty {
      if transactions.isEmpty && !noTransactions {
        collectionView.backgroundView = .loadingView(frame: collectionView.bounds, contentType: .transactions)
      } else {
        collectionView.backgroundView = .noContentView(frame: collectionView.bounds, type: .transactions)
      }
    } else {
      if !transactionsError.isEmpty {
        collectionView.backgroundView = .errorView(frame: collectionView.bounds, text: transactionsError)
      } else {
        if collectionView.backgroundView != nil {
          collectionView.backgroundView = nil
        }
      }
    }

    dataSource.apply(snapshot, animatingDifferences: animate)
  }

  private func fetchTransactions() {
    Up.listTransactions { (result) in
      DispatchQueue.main.async {
        switch result {
        case let .success(transactions):
          self.display(transactions)
        case let .failure(error):
          self.display(error)
        }
      }
    }
  }

  private func display(_ transactions: [TransactionResource]) {
    transactionsError = ""
    self.transactions = transactions
  }

  private func display(_ error: AFError) {
    transactionsError = error.errorDescription ?? error.localizedDescription
    transactions.removeAll()
  }

  @objc
  private func settledOnlyAction() {
    settledOnlyFilter.toggle()
  }

  @objc
  private func categoryAction(_ sender: NSMenuItem) {
    if let value = sender.representedObject as? TransactionCategory {
      categoryFilter = value
    }
  }

  deinit {
    removeObservers()
    print("\(#function) \(String(describing: type(of: self)))")
  }
}

// MARK: - NSToolbarDelegate

extension TransactionsVC: NSToolbarDelegate {
  func toolbar(_ toolbar: NSToolbar,
               itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
               willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
    switch itemIdentifier {
    case .categoryFilter:
      return categoryToolbarItem
    case .settledOnly:
      return settledOnlyToolbarItem
    case .flexibleSpace:
      return NSToolbarItem(itemIdentifier: itemIdentifier)
    case .transactionsSearch:
      return NSSearchToolbarItem(itemIdentifier: itemIdentifier, searchField: searchField)
    default:
      return nil
    }
  }

  func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return [.categoryFilter, .settledOnly, .flexibleSpace, .transactionsSearch]
  }

  func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return [.settledOnly]
  }

  func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return toolbarDefaultItemIdentifiers(toolbar)
  }
}

// MARK: - NSCollectionViewDelegate

extension TransactionsVC: NSCollectionViewDelegate {
  func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    guard let indexPath = indexPaths.first else { return }
    let transaction = filteredTransactions.sortedTransactionCoreModels[indexPath.section].transactions[indexPath.item]
    let viewController = TransactionDetailVC(parent ?? self, previousTitle: "Transactions", transaction: transaction)
    collectionView.deselectItems(at: indexPaths)
    view.window?.contentViewController = .navigation(parent ?? self, to: viewController)
  }
}

// MARK: - NSSearchFieldDelegate

extension TransactionsVC: NSSearchFieldDelegate {
  func controlTextDidChange(_ obj: Notification) {
    applySnapshot()
  }
}

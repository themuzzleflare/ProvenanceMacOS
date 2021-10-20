import Cocoa
import Alamofire
import SwiftDate
import IGListKit

final class TransactionsVCAlt: NSViewController {
  private lazy var searchField = NSSearchField(self, type: .transactions)

  private var categorySegmentedControl: NSSegmentedControl {
    return .categories(menu: categoryMenu)
  }

  private lazy var categoryToolbarItem = NSToolbarItem.categories(segmentedControl: categorySegmentedControl,
                                                                  menuFormRepresentation: categoryMenuFormRepresentation)

  private lazy var settledOnlyToolbarItem = NSToolbarItem.settledOnlyButton(self,
                                                                            action: #selector(settledOnlyToolbarAction),
                                                                            menuFormRepresentation: settledOnlyMenuFormRepresentation)

  private var categoryMenu: NSMenu {
    return .categoryMenu(self, filter: categoryFilter, action: #selector(categoryButtonAction(_:)))
  }

  private var categoryMenuFormRepresentation: NSMenuItem {
    return .categoryMenuFormRepresentation(category: categoryFilter, submenu: categoryMenu)
  }

  private var settledOnlyMenuFormRepresentation: NSMenuItem {
    return .settledOnlyMenuFormRepresentation(self, filter: showSettledOnly, action: #selector(settledOnlyToolbarAction))
  }

  private lazy var toolbar = NSToolbar(self, identifier: .transactions)

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

  private var oldTransactionCellModels = [TransactionCellModel]()

  private var filteredTransactions: [TransactionResource] {
    return preFilteredTransactions.filtered(searchField: searchField)
  }

  private var preFilteredTransactions: [TransactionResource] {
    return transactions.filter { (transaction) in
      return (!showSettledOnly || transaction.attributes.status.isSettled) &&
      (categoryFilter == .all || categoryFilter.rawValue == transaction.relationships.category.data?.id)
    }
  }

  private var categoryFilter: TransactionCategory = ProvenanceApp.userDefaults.appSelectedCategory {
    didSet {
      if ProvenanceApp.userDefaults.selectedCategory != categoryFilter.rawValue {
        ProvenanceApp.userDefaults.selectedCategory = categoryFilter.rawValue
      }
      filterUpdates()
    }
  }

  private var showSettledOnly: Bool = ProvenanceApp.userDefaults.settledOnly {
    didSet {
      if ProvenanceApp.userDefaults.settledOnly != showSettledOnly {
        ProvenanceApp.userDefaults.settledOnly = showSettledOnly
      }
      filterUpdates()
    }
  }

  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.register(.transactionItem, forItemWithIdentifier: .transactionItem)
      collectionView.collectionViewLayout = .list
      collectionView.backgroundViewScrollsWithContent = true
    }
  }

  override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: "TransactionsAlt", bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureObservers()
    applySnapshot(override: true)
  }

  override func viewWillAppear() {
    super.viewWillAppear()
    fetchingTasks()
    configureWindow()
    guard let appDelegate = NSApp.delegate as? AppDelegate else { return }
    appDelegate.refreshMenuItem.title = "Refresh Transactions"
    appDelegate.refreshMenuItem.action = #selector(refreshTransactions)
  }

  @objc
  private func refreshTransactions() {
    fetchTransactions()
  }

  private func configureWindow() {
    AppDelegate.windowController?.window?.toolbar = toolbar
    AppDelegate.windowController?.window?.title = "Transactions"
    toolbar.selectedItemIdentifier = showSettledOnly ? .settledOnly : nil
  }

  private func configureObservers() {
    apiKeyObserver = ProvenanceApp.userDefaults.observe(\.apiKey, options: .new) { [weak self] (_, _) in
      guard let weakSelf = self else { return }
      weakSelf.fetchingTasks()
    }
    dateStyleObserver = ProvenanceApp.userDefaults.observe(\.dateStyle, options: .new) { [weak self] (_, _) in
      guard let weakSelf = self else { return }
      weakSelf.applySnapshot()
    }
    settledOnlyObserver = ProvenanceApp.userDefaults.observe(\.settledOnly, options: .new) { [weak self] (_, change) in
      guard let weakSelf = self, let value = change.newValue else { return }
      weakSelf.showSettledOnly = value
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
    categoryToolbarItem.view = categorySegmentedControl
    categoryToolbarItem.image = categoryFilter == .all ? .trayFull : .trayFullFill
    categoryToolbarItem.menuFormRepresentation = categoryMenuFormRepresentation
    settledOnlyToolbarItem.image = showSettledOnly ? .checkmarkCircleFill.withSymbolConfiguration(.small) : .checkmarkCircle.withSymbolConfiguration(.small)
    settledOnlyToolbarItem.menuFormRepresentation = settledOnlyMenuFormRepresentation
    searchField.placeholderString = preFilteredTransactions.searchFieldPlaceholder
    applySnapshot()
  }

  private func fetchingTasks() {
    fetchTransactions()
  }

  private func applySnapshot(override: Bool = false) {
    let result = ListDiffPaths(
      fromSection: 0,
      toSection: 0,
      oldArray: oldTransactionCellModels,
      newArray: filteredTransactions.transactionCellModels,
      option: .equality
    ).forBatchUpdates()

    if result.hasChanges || override || !transactionsError.isEmpty || noTransactions {
      if filteredTransactions.isEmpty && transactionsError.isEmpty {
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

      collectionView.animator().performBatchUpdates {
        collectionView.deleteItems(at: result.deletes.set)
        collectionView.insertItems(at: result.inserts.set)
        result.moves.forEach { collectionView.moveItem(at: $0.from, to: $0.to) }
        collectionView.reloadItems(at: result.updates.set)
        oldTransactionCellModels = filteredTransactions.transactionCellModels
      }
    }
  }

  private func fetchTransactions() {
    UpFacade.listTransactions { (result) in
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
    transactionsError = .emptyString
    self.transactions = transactions
  }

  private func display(_ error: AFError) {
    transactionsError = error.errorDescription ?? error.localizedDescription
    transactions.removeAll()
  }

  @objc
  private func settledOnlyToolbarAction() {
    showSettledOnly.toggle()
    toolbar.selectedItemIdentifier = showSettledOnly ? .settledOnly : nil
  }

  @objc
  private func categoryButtonAction(_ sender: NSMenuItem) {
    if let value = TransactionCategory.allCases.first(where: { $0.description == sender.title }) {
      categoryFilter = value
    }
  }

  deinit {
    removeObservers()
    print("deinit")
  }
}

// MARK: - NSToolbarDelegate

extension TransactionsVCAlt: NSToolbarDelegate {
  func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
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

// MARK: - NSCollectionViewDataSource

extension TransactionsVCAlt: NSCollectionViewDataSource {
  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return filteredTransactions.count
  }

  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    guard let item = collectionView.makeItem(withIdentifier: .transactionItem, for: indexPath) as? TransactionItem else { fatalError() }
    item.transaction = filteredTransactions[indexPath.item].transactionViewModel
    return item
  }
}

// MARK: - NSCollectionViewDelegate

extension TransactionsVCAlt: NSCollectionViewDelegate {
  func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    guard let indexPath = indexPaths.first else { return }
    let transaction = filteredTransactions[indexPath.item]
    let viewController = TransactionDetailVC(parent ?? self, previousTitle: "Transactions", transaction: transaction)
    collectionView.deselectItems(at: indexPaths)
    view.window?.contentViewController = .navigation(parent ?? self, to: viewController)
  }
}

// MARK: - NSSearchFieldDelegate

extension TransactionsVCAlt: NSSearchFieldDelegate {
  func controlTextDidChange(_ obj: Notification) {
    applySnapshot()
  }
}

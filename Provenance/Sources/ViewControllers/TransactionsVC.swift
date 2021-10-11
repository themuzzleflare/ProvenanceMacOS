import Cocoa
import Alamofire
import SwiftDate

final class TransactionsVC: NSViewController {
  private lazy var searchField: NSSearchField = {
    let field = NSSearchField()
    field.delegate = self
    field.placeholderString = "Search Transactions"
    return field
  }()
  
  private lazy var categoryPopupButton: NSPopUpButton = {
    let button = NSPopUpButton()
    button.addItems(withTitles: TransactionCategory.allCases.names)
    button.selectItem(withTitle: categoryFilter.description)
    button.action = #selector(categoryButtonAction)
    return button
  }()
  
  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(.transactionItem, forItemWithIdentifier: .transactionItem)
      collectionView.register(.dateSupplementaryView, forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader, withIdentifier: .dateSupplementaryView)
      collectionView.collectionViewLayout = .listPinnedHeaders
      collectionView.backgroundViewScrollsWithContent = true
    }
  }
  
  @objc private func categoryButtonAction() {
    if let value = TransactionCategory.allCases.first(where: { $0.description == categoryPopupButton.titleOfSelectedItem }) {
      categoryFilter = value
    }
  }
  
  private typealias DataSource = NSCollectionViewDiffableDataSource<SortedTransactionModel, TransactionViewModel>
  
  private typealias Snapshot = NSDiffableDataSourceSnapshot<SortedTransactionModel, TransactionViewModel>
  
  private lazy var dataSource = makeDataSource()
  
  private lazy var toolbar = NSToolbar(self, type: .transactions)
  
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
      return (!showSettledOnly || transaction.attributes.status.isSettled) && (categoryFilter == .all || categoryFilter.rawValue == transaction.relationships.category.data?.id)
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
  
  override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: "Transactions", bundle: nil)
  }
  
  deinit {
    removeObservers()
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
    searchField.placeholderString = preFilteredTransactions.searchFieldPlaceholder
    applySnapshot()
  }
  
  private func fetchingTasks() {
    fetchTransactions()
  }
  
  private func makeDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: collectionView,
      itemProvider: { (collectionView, indexPath, transaction) in
        guard let item = collectionView.makeItem(withIdentifier: .transactionItem, for: indexPath) as? TransactionItem else { fatalError() }
        item.transaction = transaction
        return item
      }
    )
    dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
      guard let view = collectionView.makeSupplementaryView(ofKind: kind, withIdentifier: .dateSupplementaryView, for: indexPath) as? DateSupplementaryView else { fatalError() }
      view.label.stringValue = self.filteredTransactions.sortedTransactionModels[indexPath.section].id.toString(.date(.medium))
      return view
    }
    return dataSource
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
  
  @objc private func settledOnlyToolbarAction() {
    showSettledOnly.toggle()
    toolbar.selectedItemIdentifier = showSettledOnly ? .settledOnly : nil
  }
}

// MARK: - NSToolbarDelegate

extension TransactionsVC: NSToolbarDelegate {
  func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
    switch itemIdentifier {
    case .categoryFilter:
      return NSToolbarItem(itemIdentifier: itemIdentifier, view: categoryPopupButton)
    case .settledOnly:
      return .settledOnlyButton(action: #selector(settledOnlyToolbarAction))
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

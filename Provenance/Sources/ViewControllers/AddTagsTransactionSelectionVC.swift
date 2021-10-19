import Cocoa
import Alamofire

final class AddTagsTransactionSelectionVC: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(.transactionItem, forItemWithIdentifier: .transactionItem)
      collectionView.collectionViewLayout = .list
      collectionView.backgroundViewScrollsWithContent = true
    }
  }
  
  private var previousViewController: NSViewController
  
  private var previousTitle: String
  
  private enum Section {
    case main
  }
  
  private typealias DataSource = NSCollectionViewDiffableDataSource<Section, TransactionViewModel>
  
  private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TransactionViewModel>
  
  private lazy var dataSource = makeDataSource()
  
  private lazy var searchField = NSSearchField(self, type: .transactions)
  
  private lazy var toolbar = NSToolbar(self, identifier: .selectTransaction)
  
  private var dateStyleObserver: NSKeyValueObservation?
  
  private var noTransactions: Bool = false
  
  private var transactionsError = String()
  
  private var transactions = [TransactionResource]() {
    didSet {
      transactionsUpdates()
    }
  }
  
  private var filteredTransactions: [TransactionResource] {
    return transactions.filtered(searchField: searchField)
  }
  
  init(_ previousViewController: NSViewController, previousTitle: String) {
    self.previousViewController = previousViewController
    self.previousTitle = previousTitle
    super.init(nibName: "AddTagsTransactionSelection", bundle: nil)
  }
  
  deinit {
    removeObserver()
    print("deinit")
  }
  
  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureObserver()
    applySnapshot(animate: false)
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    fetchingTasks()
    configureWindow()
    guard let appDelegate = NSApp.delegate as? AppDelegate else { return }
    appDelegate.refreshMenuItem.title = "Refresh Transactions"
    appDelegate.refreshMenuItem.action = #selector(refreshTransactions)
  }
  
  override func viewWillDisappear() {
    super.viewWillDisappear()
    guard let appDelegate = NSApp.delegate as? AppDelegate else { return }
    appDelegate.refreshMenuItem.title = "Refresh"
    appDelegate.refreshMenuItem.action = nil
  }
  
  @objc private func refreshTransactions() {
    fetchTransactions()
  }
  
  private func configureWindow() {
    NSApp.mainWindow?.toolbar = toolbar
    NSApp.mainWindow?.title = "Select Transaction"
  }
  
  private func configureObserver() {
    dateStyleObserver = ProvenanceApp.userDefaults.observe(\.dateStyle, options: .new) { [weak self] (_, _) in
      guard let weakSelf = self else { return }
      weakSelf.applySnapshot()
    }
  }
  
  private func removeObserver() {
    dateStyleObserver?.invalidate()
    dateStyleObserver = nil
  }
  
  private func transactionsUpdates() {
    noTransactions = transactions.isEmpty
    applySnapshot()
    searchField.placeholderString = transactions.searchFieldPlaceholder
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
      }
    )
  }
  
  private func applySnapshot(animate: Bool = true) {
    var snapshot = Snapshot()
    
    snapshot.appendSections([.main])
    snapshot.appendItems(filteredTransactions.transactionViewModels, toSection: .main)
    
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
  
  @objc private func goBack() {
    view.window?.contentViewController = .navigation(self, to: previousViewController)
  }
}

// MARK: - NSToolbarDelegate

extension AddTagsTransactionSelectionVC: NSToolbarDelegate {
  func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
    switch itemIdentifier {
    case .backButton:
      return .backButton(self, title: previousTitle, action: #selector(goBack))
    case .selectTransactionsSearch:
      return NSSearchToolbarItem(itemIdentifier: itemIdentifier, searchField: searchField)
    default:
      return nil
    }
  }
  
  func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return [.backButton, .selectTransactionsSearch]
  }
  
  func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return toolbarDefaultItemIdentifiers(toolbar)
  }
}

// MARK: - NSCollectionViewDelegate

extension AddTagsTransactionSelectionVC: NSCollectionViewDelegate {
  func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    guard let indexPath = indexPaths.first else { return }
    let transaction = filteredTransactions[indexPath.item]
    let viewController = AddTagsTagSelectionVC(self, transaction: transaction)
    collectionView.deselectItems(at: indexPaths)
    view.window?.contentViewController = .navigation(self, to: viewController)
  }
}

// MARK: - NSSearchFieldDelegate

extension AddTagsTransactionSelectionVC: NSSearchFieldDelegate {
  func controlTextDidChange(_ obj: Notification) {
    applySnapshot()
  }
}

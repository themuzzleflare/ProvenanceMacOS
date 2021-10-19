import Cocoa
import Alamofire

final class TransactionsByAccountVC: NSViewController {
  private typealias DataSource = NSCollectionViewDiffableDataSource<Section, TransactionViewModel>

  private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TransactionViewModel>

  private enum Section {
    case main
  }

  private var account: AccountResource

  private lazy var dataSource = makeDataSource()

  private lazy var toolbar = NSToolbar(self, identifier: .filteredTransactions)

  private lazy var searchField = NSSearchField(self, type: .transactions)

  private var dateStyleObserver: NSKeyValueObservation?

  private var noTransactions: Bool = false

  private var transactionsError = String()

  private var transactions = [TransactionResource]() {
    didSet {
      transactionsUpdates()
    }
  }

  var filteredTransactions: [TransactionResource] {
    return transactions.filtered(searchField: searchField)
  }

  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(.transactionItem, forItemWithIdentifier: .transactionItem)
      collectionView.collectionViewLayout = .list
      collectionView.backgroundViewScrollsWithContent = true
    }
  }

  init(account: AccountResource) {
    self.account = account
    super.init(nibName: "TransactionsByAccount", bundle: nil)
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
  }

  private func configureWindow() {
    view.window?.toolbar = toolbar
    view.window?.title = account.attributes.displayName
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
    searchField.placeholderString = filteredTransactions.searchFieldPlaceholder
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

  func fetchTransactions() {
    UpFacade.listTransactions(filterBy: account) { (result) in
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

  deinit {
    removeObserver()
    print("deinit")
  }
}

// MARK: - NSToolbarDelegate

extension TransactionsByAccountVC: NSToolbarDelegate {
  func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
    switch itemIdentifier {
    case .filteredTransactionsSearch:
      return NSSearchToolbarItem(itemIdentifier: itemIdentifier, searchField: searchField)
    default:
      return nil
    }
  }

  func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return [.filteredTransactionsSearch]
  }

  func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return toolbarDefaultItemIdentifiers(toolbar)
  }
}

// MARK: - NSSearchFieldDelegate

extension TransactionsByAccountVC: NSSearchFieldDelegate {
  func controlTextDidChange(_ obj: Notification) {
    applySnapshot()
  }
}

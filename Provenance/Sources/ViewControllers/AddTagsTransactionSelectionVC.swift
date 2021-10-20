import Cocoa
import Alamofire

final class AddTagsTransactionSelectionVC: NSViewController {
  private typealias DataSource = NSCollectionViewDiffableDataSource<Section, TransactionViewModel>

  private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TransactionViewModel>

  private enum Section {
    case main
  }

  private var previousViewController: NSViewController

  private var previousTitle: String

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

  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(.transactionItem, forItemWithIdentifier: .transactionItem)
      collectionView.collectionViewLayout = .list
      collectionView.backgroundViewScrollsWithContent = true
    }
  }

  init(_ previousViewController: NSViewController, previousTitle: String) {
    self.previousViewController = previousViewController
    self.previousTitle = previousTitle
    super.init(nibName: "AddTagsTransactionSelection", bundle: nil)
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
    appDelegate.refreshMenuItem.target = self
    appDelegate.refreshMenuItem.action = #selector(refreshTransactions)
  }

  override func viewWillDisappear() {
    super.viewWillDisappear()
    guard let appDelegate = NSApp.delegate as? AppDelegate else { return }
    appDelegate.refreshMenuItem.title = "Refresh"
    appDelegate.refreshMenuItem.action = nil
  }

  @objc
  private func refreshTransactions() {
    fetchTransactions()
  }

  private func configureWindow() {
    AppDelegate.windowController?.window?.toolbar = toolbar
    AppDelegate.windowController?.window?.title = "Select Transaction"
  }

  private func configureObserver() {
    dateStyleObserver = App.userDefaults.observe(\.dateStyle, options: .new) { [weak self] (_, _) in
      self?.applySnapshot()
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
    transactionsError = .emptyString
    self.transactions = transactions
  }

  private func display(_ error: AFError) {
    transactionsError = error.errorDescription ?? error.localizedDescription
    transactions.removeAll()
  }

  @objc
  private func goBack() {
    view.window?.contentViewController = .navigation(self, to: previousViewController)
  }

  deinit {
    removeObserver()
    print("deinit")
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

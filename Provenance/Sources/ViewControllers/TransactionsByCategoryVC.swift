import Cocoa
import Alamofire

final class FilteredTransactionsVC: NSViewController {
  @IBOutlet weak var searchField: NSSearchField!
  
  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(TransactionItem.nib, forItemWithIdentifier: TransactionItem.reuseIdentifier)
      collectionView.collectionViewLayout = .listLayout
      collectionView.backgroundViewScrollsWithContent = true
    }
  }
  
  @IBAction func backButtonAction(_ sender: NSButton) {
    previousViewController.view.setFrameOrigin(NSPoint(x: 0, y: 0))
    previousViewController.view.setFrameSize(view.frame.size)
    view.window?.contentViewController = previousViewController
  }
  
  private var previousViewController: NSViewController
  
  private var category: CategoryResource
  
  private enum Section {
    case main
  }
  
  private typealias DataSource = NSCollectionViewDiffableDataSource<Section, TransactionCellModel>
  
  private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TransactionCellModel>
  
  private lazy var dataSource = makeDataSource()
  
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
  
  init(_ previousViewController: NSViewController, category: CategoryResource) {
    self.previousViewController = previousViewController
    self.category = category
    super.init(nibName: "TransactionsByCategory", bundle: nil)
  }
  
  deinit {
    removeObserver()
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
    AppDelegate.windowController?.window?.title = category.attributes.name
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
        guard let item = collectionView.makeItem(withIdentifier: TransactionItem.reuseIdentifier, for: indexPath) as? TransactionItem else { fatalError() }
        item.transaction = transaction
        return item
      }
    )
  }
  
  private func applySnapshot(animate: Bool = true) {
    var snapshot = Snapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(filteredTransactions.transactionCellModels, toSection: .main)
    
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
    
    dataSource.apply(snapshot, animatingDifferences: animate)
  }
  
  private func fetchTransactions() {
    UpFacade.listTransactions(filterBy: category) { (result) in
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
}

  // MARK: - NSCollectionViewDelegate

extension FilteredTransactionsVC: NSCollectionViewDelegate {
  func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    guard let indexPath = indexPaths.first else { return }
    let transaction = filteredTransactions[indexPath.item]
    let viewController = TransactionDetailVC(self, transaction: transaction)
    collectionView.deselectItems(at: indexPaths)
    viewController.view.setFrameOrigin(NSPoint(x: 0, y: 0))
    viewController.view.setFrameSize(view.frame.size)
    view.window?.contentViewController = viewController
  }
}

  // MARK: - NSSearchFieldDelegate

extension FilteredTransactionsVC: NSSearchFieldDelegate {
  func controlTextDidChange(_ obj: Notification) {
    applySnapshot()
  }
}

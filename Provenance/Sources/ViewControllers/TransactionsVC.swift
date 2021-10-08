import Cocoa
import Alamofire

final class TransactionsVC: NSViewController {
  @IBOutlet weak var searchField: NSSearchField!
  
  @IBOutlet weak var categoryPopupButton: NSPopUpButton! {
    didSet {
      categoryPopupButton.addItems(withTitles: TransactionCategory.allCases.map { $0.name })
      categoryPopupButton.selectItem(withTitle: categoryFilter.name)
    }
  }
  
  @IBOutlet weak var settledOnlyCheckmark: NSButton! {
    didSet {
      settledOnlyCheckmark.state = showSettledOnly ? .on : .off
    }
  }
  
  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(TransactionItem.nib, forItemWithIdentifier: TransactionItem.reuseIdentifier)
      collectionView.collectionViewLayout = .listLayout
      collectionView.backgroundViewScrollsWithContent = true
    }
  }
  
  @IBAction func categoryButtonAction(_ sender: NSPopUpButton) {
    if let value = TransactionCategory.allCases.first(where: { $0.name == sender.titleOfSelectedItem }) {
      categoryFilter = value
    }
  }
  
  @IBAction func settledOnlyAction(_ sender: NSButton) {
    showSettledOnly = sender.state == .on ? true : false
  }
  
  private enum Section {
    case main
  }
  
  private typealias DataSource = NSCollectionViewDiffableDataSource<Section, TransactionCellModel>
  
  private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TransactionCellModel>
  
  private lazy var dataSource = makeDataSource()
  
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
  
  deinit {
    removeObservers()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureObservers()
    applySnapshot(animate: false)
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    fetchingTasks()
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
}

  // MARK: - NSCollectionViewDelegate

extension TransactionsVC: NSCollectionViewDelegate {
  func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    collectionView.deselectItems(at: indexPaths)
  }
}

  // MARK: - NSSearchFieldDelegate

extension TransactionsVC: NSSearchFieldDelegate {
  func controlTextDidChange(_ obj: Notification) {
    applySnapshot()
  }
}

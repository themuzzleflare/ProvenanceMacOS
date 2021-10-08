import Cocoa
import Alamofire

final class AccountsVC: NSViewController {
  @IBOutlet weak var searchField: NSSearchField!
  
  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(AccountItem.nib, forItemWithIdentifier: AccountItem.reuseIdentifier)
      collectionView.collectionViewLayout = .twoColumnGridLayout
      collectionView.backgroundViewScrollsWithContent = true
    }
  }
  
  @IBOutlet weak var accountTypeSegmentedControl: NSSegmentedControl! {
    didSet {
      accountTypeSegmentedControl.selectSegment(withTag: accountFilter.rawValue)
    }
  }
  
  @IBAction func accountTypeAction(_ sender: NSSegmentedControl) {
    if let value = AccountTypeOptionEnum(rawValue: sender.selectedSegment) {
      accountFilter = value
    }
    if !searchField.stringValue.isEmpty {
      applySnapshot()
    }
  }
  
  private enum Section {
    case main
  }
  
  private typealias DataSource = NSCollectionViewDiffableDataSource<Section, AccountCellModel>
  
  private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AccountCellModel>
  
  private lazy var dataSource = makeDataSource()
  
  private var accountFilter: AccountTypeOptionEnum = ProvenanceApp.userDefaults.appAccountFilter {
    didSet {
      if ProvenanceApp.userDefaults.accountFilter != accountFilter.rawValue {
        ProvenanceApp.userDefaults.accountFilter = accountFilter.rawValue
      }
      if accountTypeSegmentedControl.selectedSegment != accountFilter.rawValue {
        accountTypeSegmentedControl.selectSegment(withTag: accountFilter.rawValue)
      }
    }
  }
  
  private var apiKeyObserver: NSKeyValueObservation?
  
  private var accountFilterObserver: NSKeyValueObservation?
  
  private var noAccounts: Bool = false
  
  private var accounts = [AccountResource]() {
    didSet {
      noAccounts = accounts.isEmpty
      applySnapshot()
      searchField.placeholderString = accounts.searchFieldPlaceholder
    }
  }
  
  private var accountsError = String()
  
  private var filteredAccounts: [AccountResource] {
    return accounts.filtered(filter: accountFilter, searchField: searchField)
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
    fetchAccounts()
  }
  
  private func configureObservers() {
    apiKeyObserver = ProvenanceApp.userDefaults.observe(\.apiKey, options: .new) { [weak self] (_, _) in
      guard let weakSelf = self else { return }
      weakSelf.fetchAccounts()
    }
    accountFilterObserver = ProvenanceApp.userDefaults.observe(\.accountFilter, options: .new) { [weak self] (_, change) in
      guard let weakSelf = self, let value = change.newValue, let accountFilter = AccountTypeOptionEnum(rawValue: value) else { return }
      weakSelf.accountFilter = accountFilter
    }
  }
  
  private func removeObservers() {
    apiKeyObserver?.invalidate()
    apiKeyObserver = nil
    accountFilterObserver?.invalidate()
    accountFilterObserver = nil
  }
  
  private func makeDataSource() -> DataSource {
    return DataSource(
      collectionView: collectionView,
      itemProvider: { (collectionView, indexPath, account) in
        guard let item = collectionView.makeItem(withIdentifier: AccountItem.reuseIdentifier, for: indexPath) as? AccountItem else { fatalError() }
        item.account = account
        return item
      }
    )
  }
  
  private func applySnapshot(animate: Bool = true) {
    var snapshot = Snapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(filteredAccounts.accountCellModels, toSection: .main)
    
    if filteredAccounts.isEmpty && accountsError.isEmpty {
      if accounts.isEmpty && !noAccounts {
        collectionView.backgroundView = .loadingView(frame: collectionView.bounds, contentType: .accounts)
      } else {
        collectionView.backgroundView = .noContentView(frame: collectionView.bounds, type: .accounts)
      }
    } else {
      if !accountsError.isEmpty {
        collectionView.backgroundView = .errorView(frame: collectionView.bounds, text: accountsError)
      } else {
        if collectionView.backgroundView != nil {
          collectionView.backgroundView = nil
        }
      }
    }
    
    dataSource.apply(snapshot, animatingDifferences: animate)
  }
  
  private func fetchAccounts() {
    UpFacade.listAccounts { (result) in
      DispatchQueue.main.async {
        switch result {
        case let .success(accounts):
          self.display(accounts)
        case let .failure(error):
          self.display(error)
        }
      }
    }
  }
  
  private func display(_ accounts: [AccountResource]) {
    accountsError = .emptyString
    self.accounts = accounts
  }
  
  private func display(_ error: AFError) {
    accountsError = error.errorDescription ?? error.localizedDescription
    accounts.removeAll()
  }
}

  // MARK: - NSCollectionViewDelegate

extension AccountsVC: NSCollectionViewDelegate {
  func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    collectionView.deselectItems(at: indexPaths)
  }
}

  // MARK: - NSSearchFieldDelegate

extension AccountsVC: NSSearchFieldDelegate {
  func controlTextDidChange(_ obj: Notification) {
    applySnapshot()
  }
  
  func searchFieldDidStartSearching(_ sender: NSSearchField) {
    accountTypeSegmentedControl.isHidden = false
  }
  
  func searchFieldDidEndSearching(_ sender: NSSearchField) {
    accountTypeSegmentedControl.isHidden = true
  }
}

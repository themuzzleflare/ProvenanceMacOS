import Cocoa
import Alamofire

final class AccountsVC: NSViewController {
  private typealias DataSource = NSCollectionViewDiffableDataSource<Section, AccountViewModel>

  private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AccountViewModel>

  private enum Section {
    case main
  }

  private lazy var dataSource = makeDataSource()

  private lazy var toolbar = NSToolbar(self, identifier: .accounts)

  private lazy var searchField = NSSearchField(self, type: .accounts)

  private lazy var accountFilter: AccountTypeOptionEnum = App.userDefaults.appAccountFilter {
    didSet {
      if App.userDefaults.accountFilter != accountFilter.rawValue {
        App.userDefaults.accountFilter = accountFilter.rawValue
      }
      if accountTypeSegmentedControl.selectedSegment != accountFilter.rawValue {
        accountTypeSegmentedControl.selectSegment(withTag: accountFilter.rawValue)
      }
      if !searchField.stringValue.isEmpty {
        applySnapshot()
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

  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(.accountItem, forItemWithIdentifier: .accountItem)
      collectionView.collectionViewLayout = .twoColumnGrid
      collectionView.backgroundViewScrollsWithContent = true
    }
  }

  @IBOutlet weak var accountTypeSegmentedControl: NSSegmentedControl! {
    didSet {
      accountTypeSegmentedControl.selectSegment(withTag: accountFilter.rawValue)
    }
  }

  override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: "Accounts", bundle: nil)
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
    fetchAccounts()
    configureWindow()
    guard let appDelegate = NSApp.delegate as? AppDelegate else { return }
    appDelegate.refreshMenuItem.title = "Refresh Accounts"
    appDelegate.refreshMenuItem.target = self
    appDelegate.refreshMenuItem.action = #selector(refreshAccounts)
  }

  @IBAction func accountTypeAction(_ sender: NSSegmentedControl) {
    if let value = AccountTypeOptionEnum(rawValue: sender.selectedSegment) {
      accountFilter = value
    }
  }

  @objc
  private func refreshAccounts() {
    fetchAccounts()
  }

  private func configureWindow() {
    AppDelegate.windowController?.window?.toolbar = toolbar
    AppDelegate.windowController?.window?.title = "Accounts"
  }

  private func configureObservers() {
    apiKeyObserver = App.userDefaults.observe(\.apiKey, options: .new) { [weak self] (_, _) in
      self?.fetchAccounts()
    }
    accountFilterObserver = App.userDefaults.observe(\.accountFilter, options: .new) { [weak self] (_, change) in
      guard let value = change.newValue,
            let accountTypeOptionEnum = AccountTypeOptionEnum(rawValue: value) else { return }
      self?.accountFilter = accountTypeOptionEnum
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
        guard let item = collectionView.makeItem(withIdentifier: .accountItem, for: indexPath) as? AccountItem else { fatalError() }
        item.account = account
        return item
      }
    )
  }

  private func applySnapshot(animate: Bool = true) {
    var snapshot = Snapshot()

    snapshot.appendSections([.main])
    snapshot.appendItems(filteredAccounts.accountViewModels, toSection: .main)

    if snapshot.itemIdentifiers.isEmpty && accountsError.isEmpty {
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
    Up.listAccounts { (result) in
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
    accountsError = ""
    self.accounts = accounts
  }

  private func display(_ error: AFError) {
    accountsError = error.errorDescription ?? error.localizedDescription
    accounts.removeAll()
  }

  deinit {
    removeObservers()
    print("deinit")
  }
}

// MARK: - NSToolbarDelegate

extension AccountsVC: NSToolbarDelegate {
  func toolbar(_ toolbar: NSToolbar,
               itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
               willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
    switch itemIdentifier {
    case .accountsSearch:
      return NSSearchToolbarItem(itemIdentifier: itemIdentifier, searchField: searchField)
    default:
      return nil
    }
  }

  func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return [.accountsSearch]
  }

  func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return toolbarDefaultItemIdentifiers(toolbar)
  }
}

// MARK: - NSCollectionViewDelegate

extension AccountsVC: NSCollectionViewDelegate {
  func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    guard let indexPath = indexPaths.first else { return }
    let account = filteredAccounts[indexPath.item]
    let viewController = FilteredTransactionsVC(parent ?? self, previousTitle: "Accounts", resource: .account(account))
    collectionView.deselectItems(at: indexPaths)
    view.window?.contentViewController = .navigation(parent ?? self, to: viewController)
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

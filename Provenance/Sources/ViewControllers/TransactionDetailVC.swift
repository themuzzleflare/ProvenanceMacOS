import Cocoa
import Alamofire

final class TransactionDetailVC: NSViewController {
  private typealias DataSource = NSCollectionViewDiffableDataSource<DetailSection, DetailItem>

  private typealias Snapshot = NSDiffableDataSourceSnapshot<DetailSection, DetailItem>

  private var previousViewController: NSViewController

  private var previousTitle: String

  private var transaction: TransactionResource {
    didSet {
      fetchingTasks()
    }
  }

  private lazy var dataSource = makeDataSource()

  private lazy var toolbar = NSToolbar(self, identifier: .transactionDetail)

  private var dateStyleObserver: NSKeyValueObservation?

  private var filteredSections: [DetailSection] {
    return .transactionDetailSections(
      transaction: transaction,
      account: account,
      transferAccount: transferAccount,
      parentCategory: parentCategory,
      category: category
    ).filtered
  }

  private var account: AccountResource? {
    didSet {
      applySnapshot()
    }
  }

  private var transferAccount: AccountResource? {
    didSet {
      applySnapshot()
    }
  }

  private var parentCategory: CategoryResource? {
    didSet {
      applySnapshot()
    }
  }

  private var category: CategoryResource? {
    didSet {
      applySnapshot()
    }
  }

  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(.attributeItem, forItemWithIdentifier: .attributeItem)
      collectionView.collectionViewLayout = .transactionDetail
    }
  }

  init(_ previousViewController: NSViewController, previousTitle: String, transaction: TransactionResource) {
    self.previousViewController = previousViewController
    self.previousTitle = previousTitle
    self.transaction = transaction
    super.init(nibName: "TransactionDetail", bundle: nil)
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
    fetchTransaction()
    configureWindow()
    guard let appDelegate = NSApp.delegate as? AppDelegate else { return }
    appDelegate.refreshMenuItem.title = "Refresh \(transaction.attributes.description)"
    appDelegate.refreshMenuItem.action = #selector(refreshTransaction)
  }

  override func viewWillDisappear() {
    super.viewWillDisappear()
    guard let appDelegate = NSApp.delegate as? AppDelegate else { return }
    appDelegate.refreshMenuItem.title = "Refresh"
    appDelegate.refreshMenuItem.action = nil
  }

  @objc
  private func refreshTransaction() {
    fetchTransaction()
  }

  private func configureWindow() {
    NSApp.mainWindow?.toolbar = toolbar
    NSApp.mainWindow?.title = transaction.attributes.description
  }

  @objc
  private func goBack() {
    view.window?.contentViewController = .navigation(self, to: previousViewController)
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

  private func fetchingTasks() {
    UpFacade.retrieveAccount(for: transaction.relationships.account.data.id) { (result) in
      DispatchQueue.main.async {
        switch result {
        case let .success(account):
          self.account = account
        case .failure:
          break
        }
      }
    }

    if let tAccount = transaction.relationships.transferAccount.data {
      UpFacade.retrieveAccount(for: tAccount.id) { (result) in
        DispatchQueue.main.async {
          switch result {
          case let .success(account):
            self.transferAccount = account
          case .failure:
            break
          }
        }
      }
    }

    if let pCategory = transaction.relationships.parentCategory.data {
      UpFacade.retrieveCategory(for: pCategory.id) { (result) in
        DispatchQueue.main.async {
          switch result {
          case let .success(category):
            self.parentCategory = category
          case .failure:
            break
          }
        }
      }
    } else {
      self.parentCategory = nil
    }

    if let category = transaction.relationships.category.data {
      UpFacade.retrieveCategory(for: category.id) { (result) in
        DispatchQueue.main.async {
          switch result {
          case let .success(category):
            self.category = category
          case .failure:
            break
          }
        }
      }
    } else {
      self.category = nil
    }
  }

  private func makeDataSource() -> DataSource {
    return DataSource(
      collectionView: collectionView,
      itemProvider: { (collectionView, indexPath, attribute) in
        guard let item = collectionView.makeItem(withIdentifier: .attributeItem, for: indexPath) as? AttributeItem else { fatalError() }
        item.attribute = attribute
        return item
      }
    )
  }

  private func applySnapshot(animate: Bool = true) {
    var snapshot = Snapshot()
    snapshot.appendSections(filteredSections)
    filteredSections.forEach { snapshot.appendItems($0.items, toSection: $0) }
    dataSource.apply(snapshot, animatingDifferences: animate)
  }

  private func fetchTransaction() {
    UpFacade.retrieveTransaction(for: transaction) { (result) in
      DispatchQueue.main.async {
        switch result {
        case let .success(transaction):
          self.display(transaction)
        case let .failure(error):
          self.display(error)
        }
      }
    }
  }

  private func display(_ transaction: TransactionResource) {
    self.transaction = transaction
  }

  private func display(_ error: AFError) {
  }

  @objc
  private func openTransactionStatusView() {
    presentAsSheet(TransactionStatusVC())
  }

  deinit {
    removeObserver()
    print("deinit")
  }
}

// MARK: - NSToolbarDelegate

extension TransactionDetailVC: NSToolbarDelegate {
  func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
    switch itemIdentifier {
    case .backButton:
      return .backButton(self, title: previousTitle, action: #selector(goBack))
    case .transactionStatus:
      return .transactionStatusIcon(self, status: transaction.attributes.status, action: #selector(openTransactionStatusView))
    default:
      return nil
    }
  }

  func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return [.backButton, .transactionStatus]
  }

  func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return toolbarDefaultItemIdentifiers(toolbar)
  }
}

// MARK: - NSCollectionViewDelegate

extension TransactionDetailVC: NSCollectionViewDelegate {
  func collectionView(_ collectionView: NSCollectionView, shouldChangeItemsAt indexPaths: Set<IndexPath>, to highlightState: NSCollectionViewItem.HighlightState) -> Set<IndexPath> {
    guard let indexPath = indexPaths.first, let attribute = dataSource.itemIdentifier(for: indexPath), (attribute.id == "Account" || attribute.id == "Transfer Account" || attribute.id == "Parent Category" || attribute.id == "Category" || attribute.id == "Tags") else { return Set() }
    return indexPaths
  }

  func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    collectionView.deselectItems(at: indexPaths)
    if let indexPath = indexPaths.first, let attribute = dataSource.itemIdentifier(for: indexPath) {
      switch attribute.id {
      case "Account":
        if let accountResource = account {
          let viewController = FilteredTransactionsVC(self, previousTitle: transaction.attributes.description, resource: .account(accountResource))
          view.window?.contentViewController = .navigation(self, to: viewController)
        }
      case "Transfer Account":
        if let accountResource = transferAccount {
          let viewController = FilteredTransactionsVC(self, previousTitle: transaction.attributes.description, resource: .account(accountResource))
          view.window?.contentViewController = .navigation(self, to: viewController)
        }
      case "Parent Category":
        if let categoryResource = parentCategory {
          let viewController = FilteredTransactionsVC(self, previousTitle: transaction.attributes.description, resource: .category(categoryResource))
          view.window?.contentViewController = .navigation(self, to: viewController)
        }
      case "Category":
        if let categoryResource = category {
          let viewController = FilteredTransactionsVC(self, previousTitle: transaction.attributes.description, resource: .category(categoryResource))
          view.window?.contentViewController = .navigation(self, to: viewController)
        }
      case "Tags":
        let viewController = TransactionTagsVC(self, transaction: transaction)
        view.window?.contentViewController = .navigation(self, to: viewController)
      default:
        break
      }
    }
  }
}

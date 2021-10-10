import Cocoa
import Alamofire

final class TransactionDetailVC: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(.attributeItem, forItemWithIdentifier: .attributeItem)
      collectionView.collectionViewLayout = .transactionDetail
    }
  }
  
  private var previousViewController: NSViewController
  
  private var previousTitle: String
  
  private var transaction: TransactionResource {
    didSet {
      fetchingTasks()
    }
  }
  
  private typealias DataSource = NSCollectionViewDiffableDataSource<DetailSection, DetailItem>
  
  private typealias Snapshot = NSDiffableDataSourceSnapshot<DetailSection, DetailItem>
  
  private lazy var dataSource = makeDataSource()
  
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
  
  init(_ previousViewController: NSViewController, previousTitle: String, transaction: TransactionResource) {
    self.previousViewController = previousViewController
    self.previousTitle = previousTitle
    self.transaction = transaction
    super.init(nibName: "TransactionDetail", bundle: nil)
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
    fetchTransaction()
    configureWindow()
  }
  
  private func configureWindow() {
    AppDelegate.windowController?.window?.title = transaction.attributes.description
    AppDelegate.windowController?.backButton.title = previousTitle
    AppDelegate.windowController?.backButton.action = #selector(goBack)
  }
  
  @objc private func goBack() {
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
}

  // MARK: - NSCollectionViewDelegate

extension TransactionDetailVC: NSCollectionViewDelegate {
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
        break
      default:
        break
      }
    }
  }
}

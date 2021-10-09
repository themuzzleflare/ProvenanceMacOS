import Cocoa
import Alamofire

final class TransactionDetailVC: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(AttributeItem.nib, forItemWithIdentifier: AttributeItem.reuseIdentifier)
      collectionView.collectionViewLayout = .listLayout
    }
  }
  
  @IBAction func backAction(_ sender: NSButton) {
    previousViewController.view.setFrameOrigin(NSPoint(x: 0, y: 0))
    previousViewController.view.setFrameSize(view.frame.size)
    view.window?.contentViewController = previousViewController
  }
  
  @IBOutlet weak var statusButton: NSButton! {
    didSet {
      statusButton.image = transaction.attributes.status.nsImage
      statusButton.bezelColor = transaction.attributes.status.nsColour
    }
  }
  
  private var previousViewController: NSViewController
  
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
  
  init(_ previousViewController: NSViewController, transaction: TransactionResource) {
    self.previousViewController = previousViewController
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
        guard let item = collectionView.makeItem(withIdentifier: AttributeItem.reuseIdentifier, for: indexPath) as? AttributeItem else { fatalError() }
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
  }
}

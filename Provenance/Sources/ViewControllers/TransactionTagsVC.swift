import Cocoa

final class TransactionTagsVC: NSViewController {
  private typealias DataSource = NSCollectionViewDiffableDataSource<Section, TagViewModel>

  private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TagViewModel>

  private enum Section {
    case main
  }

  private var previousViewController: NSViewController

  var transaction: TransactionResource {
    didSet {
      if transaction.relationships.tags.data.isEmpty {
        view.window?.contentViewController = .navigation(self, to: previousViewController)
      } else {
        applySnapshot()
      }
    }
  }

  var tags: [TagResource] {
    return transaction.relationships.tags.data.tagResources
  }

  private lazy var dataSource = makeDataSource()

  private lazy var toolbar = NSToolbar(self, identifier: .transactionTags)

  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(.tagItem, forItemWithIdentifier: .tagItem)
      collectionView.collectionViewLayout = .tags
    }
  }

  init(_ previousViewController: NSViewController, transaction: TransactionResource) {
    self.previousViewController = previousViewController
    self.transaction = transaction
    super.init(nibName: "TransactionTags", bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    applySnapshot(animate: false)
  }

  override func viewWillAppear() {
    super.viewWillAppear()
    fetchTransaction()
    configureWindow()
    guard let appDelegate = NSApp.delegate as? AppDelegate else { return }
    appDelegate.refreshMenuItem.title = "Refresh Tags"
    appDelegate.refreshMenuItem.target = self
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
    AppDelegate.windowController?.window?.toolbar = toolbar
    AppDelegate.windowController?.window?.title = "Tags"
  }

  private func makeDataSource() -> DataSource {
    return DataSource(
      collectionView: collectionView,
      itemProvider: { (collectionView, indexPath, tag) in
        guard let item = collectionView.makeItem(withIdentifier: .tagItem, for: indexPath) as? TagItem else { fatalError() }
        item.tag = tag
        return item
      }
    )
  }

  private func applySnapshot(animate: Bool = true) {
    var snapshot = Snapshot()

    snapshot.appendSections([.main])
    snapshot.appendItems(tags.tagViewModels, toSection: .main)

    dataSource.apply(snapshot, animatingDifferences: animate)
  }

  func fetchTransaction() {
    Up.retrieveTransaction(for: transaction) { (result) in
      DispatchQueue.main.async {
        switch result {
        case let .success(transaction):
          self.transaction = transaction
        case .failure:
          break
        }
      }
    }
  }

  @objc
  private func goBack() {
    view.window?.contentViewController = .navigation(self, to: previousViewController)
  }

  deinit {
    print("deinit")
  }
}

// MARK: - NSToolbarDelegate

extension TransactionTagsVC: NSToolbarDelegate {
  func toolbar(_ toolbar: NSToolbar,
               itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
               willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
    switch itemIdentifier {
    case .backButton:
      return .backButton(self, title: transaction.attributes.description, action: #selector(goBack))
    default:
      return nil
    }
  }

  func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return [.backButton]
  }

  func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return toolbarDefaultItemIdentifiers(toolbar)
  }
}

// MARK: - NSCollectionViewDelegate

extension TransactionTagsVC: NSCollectionViewDelegate {
  func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    guard let indexPath = indexPaths.first else { return }
    let tag = tags[indexPath.item]
    let viewController = FilteredTransactionsVC(self, previousTitle: "Tags", resource: .tag(tag))
    collectionView.deselectItems(at: indexPaths)
    view.window?.contentViewController = .navigation(self, to: viewController)
  }
}

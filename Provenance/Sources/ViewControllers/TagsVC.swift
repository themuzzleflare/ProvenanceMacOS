import Cocoa
import Alamofire

final class TagsVC: NSViewController {
  private typealias DataSource = NSCollectionViewDiffableDataSource<Section, TagViewModel>

  private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TagViewModel>

  private enum Section {
    case main
  }

  private lazy var dataSource = makeDataSource()

  private lazy var toolbar = NSToolbar(self, identifier: .tags)

  private lazy var searchField = NSSearchField(self, type: .tags)

  private var apiKeyObserver: NSKeyValueObservation?

  private var noTags: Bool = false

  private var tags = [TagResource]() {
    didSet {
      noTags = tags.isEmpty
      applySnapshot()
      searchField.placeholderString = tags.searchFieldPlaceholder
    }
  }

  private var tagsError = String()

  private var filteredTags: [TagResource] {
    return tags.filtered(searchField: searchField)
  }

  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(.tagItem, forItemWithIdentifier: .tagItem)
      collectionView.collectionViewLayout = .tags
      collectionView.backgroundViewScrollsWithContent = true
    }
  }

  override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: "Tags", bundle: nil)
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
    fetchTags()
    configureWindow()
    guard let appDelegate = NSApp.delegate as? AppDelegate else { return }
    appDelegate.refreshMenuItem.title = "Refresh Tags"
    appDelegate.refreshMenuItem.target = self
    appDelegate.refreshMenuItem.action = #selector(refreshTags)
  }

  @objc
  private func refreshTags() {
    fetchTags()
  }

  private func configureWindow() {
    AppDelegate.windowController?.window?.toolbar = toolbar
    AppDelegate.windowController?.window?.title = "Tags"
  }

  private func configureObserver() {
    apiKeyObserver = UserDefaults.provenance.observe(\.apiKey, options: .new) { [weak self] (_, _) in
      self?.fetchTags()
    }
  }

  private func removeObserver() {
    apiKeyObserver?.invalidate()
    apiKeyObserver = nil
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
    snapshot.appendItems(filteredTags.tagViewModels, toSection: .main)

    if snapshot.itemIdentifiers.isEmpty && tagsError.isEmpty {
      if tags.isEmpty && !noTags {
        collectionView.backgroundView = .loadingView(frame: collectionView.bounds, contentType: .tags)
      } else {
        collectionView.backgroundView = .noContentView(frame: collectionView.bounds, type: .tags)
      }
    } else {
      if !tagsError.isEmpty {
        collectionView.backgroundView = .errorView(frame: collectionView.bounds, text: tagsError)
      } else {
        if collectionView.backgroundView != nil {
          collectionView.backgroundView = nil
        }
      }
    }

    dataSource.apply(snapshot, animatingDifferences: animate)
  }

  private func fetchTags() {
    Up.listTags { (result) in
      DispatchQueue.main.async {
        switch result {
        case let .success(tags):
          self.display(tags)
        case let .failure(error):
          self.display(error)
        }
      }
    }
  }

  private func display(_ tags: [TagResource]) {
    tagsError = ""
    self.tags = tags
  }

  private func display(_ error: AFError) {
    tagsError = error.errorDescription ?? error.localizedDescription
    tags.removeAll()
  }

  @objc
  private func addTags() {
    let viewController = AddTagsTransactionSelectionVC(parent ?? self, previousTitle: "Tags")
    view.window?.contentViewController = .navigation(parent ?? self, to: viewController)
  }

  deinit {
    removeObserver()
    print("\(#function) \(String(describing: type(of: self)))")
  }
}

// MARK: - NSToolbarDelegate

extension TagsVC: NSToolbarDelegate {
  func toolbar(_ toolbar: NSToolbar,
               itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
               willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
    switch itemIdentifier {
    case .addTags:
      return .addTags(self, action: #selector(addTags))
    case .flexibleSpace:
      return NSToolbarItem(itemIdentifier: itemIdentifier)
    case .tagsSearch:
      return NSSearchToolbarItem(itemIdentifier: itemIdentifier, searchField: searchField)
    default:
      return nil
    }
  }

  func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return [.addTags, .flexibleSpace, .tagsSearch]
  }

  func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return toolbarDefaultItemIdentifiers(toolbar)
  }
}

// MARK: - NSToolbarItemValidation

extension TagsVC: NSToolbarItemValidation {
  @discardableResult
  func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
    switch item.itemIdentifier {
    case .addTags:
      if tagsError.isEmpty {
        item.toolTip = "Add tags."
      } else {
        item.toolTip = "Resolve the current error before adding tags."
      }
      return tagsError.isEmpty
    default:
      return true
    }
  }
}

// MARK: - NSCollectionViewDelegate

extension TagsVC: NSCollectionViewDelegate {
  func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    guard let indexPath = indexPaths.first else { return }
    let tag = filteredTags[indexPath.item]
    let viewController = FilteredTransactionsVC(parent ?? self, previousTitle: "Tags", resource: .tag(tag))
    collectionView.deselectItems(at: indexPaths)
    view.window?.contentViewController = .navigation(parent ?? self, to: viewController)
  }
}

// MARK: - NSSearchFieldDelegate

extension TagsVC: NSSearchFieldDelegate {
  func controlTextDidChange(_ obj: Notification) {
    applySnapshot()
  }
}

import Cocoa
import Alamofire

final class AddTagsTagSelectionVC: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(.tagItem, forItemWithIdentifier: .tagItem)
      collectionView.collectionViewLayout = .tags
      collectionView.backgroundViewScrollsWithContent = true
    }
  }
  
  private var previousViewController: NSViewController
  
  private var transaction: TransactionResource
  
  enum Section {
    case main
  }
  
  typealias DataSource = NSCollectionViewDiffableDataSource<Section, TagViewModel>
  
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TagViewModel>
  
  lazy var dataSource = makeDataSource()
  
  private lazy var toolbar = NSToolbar(self, identifier: .selectTags)
  
  private lazy var searchField = NSSearchField(self, type: .tags)
  
  lazy var createTagsAlert = NSAlert.createTags(self)
  
  lazy var createTagsViewController = CreateTagsVC(self)
  
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
  
  init(_ previousViewController: NSViewController, transaction: TransactionResource) {
    self.previousViewController = previousViewController
    self.transaction = transaction
    super.init(nibName: "AddTagsTagSelection", bundle: nil)
  }
  
  deinit {
    print("deinit")
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
    fetchTags()
    configureWindow()
    guard let appDelegate = NSApp.delegate as? AppDelegate else { return }
    appDelegate.refreshMenuItem.title = "Refresh Tags"
    appDelegate.refreshMenuItem.action = #selector(refreshTags)
  }
  
  override func viewWillDisappear() {
    super.viewWillDisappear()
    guard let appDelegate = NSApp.delegate as? AppDelegate else { return }
    appDelegate.refreshMenuItem.title = "Refresh"
    appDelegate.refreshMenuItem.action = nil
  }
  
  @objc private func refreshTags() {
    fetchTags()
  }
  
  private func configureWindow() {
    NSApp.mainWindow?.toolbar = toolbar
    NSApp.mainWindow?.title = "Select Tag"
  }
  
  func makeDataSource() -> DataSource {
    return DataSource(
      collectionView: collectionView,
      itemProvider: { [weak self] (collectionView, indexPath, tag) in
        guard let item = collectionView.makeItem(withIdentifier: .tagItem, for: indexPath) as? TagItem else { fatalError() }
        item.delegate = self
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
    UpFacade.listTags { (result) in
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
    tagsError = .emptyString
    self.tags = tags
  }
  
  private func display(_ error: AFError) {
    tagsError = error.errorDescription ?? error.localizedDescription
    tags.removeAll()
  }
  
  @objc private func goBack() {
    view.window?.contentViewController = .navigation(self, to: previousViewController)
  }
  
  @objc private func next() {
    let selectedTags = collectionView.selectionIndexPaths.map { (indexPath) in
      return filteredTags[indexPath.item]
    }
    let viewController = AddTagsConfirmationVC(self, transaction: transaction, tags: selectedTags)
    view.window?.contentViewController = .navigation(self, to: viewController)
  }
  
  @objc private func createTag() {
    switch createTagsAlert.runModal() {
    case .alertFirstButtonReturn:
      let tags = createTagsViewController.textFields.tagResources
      let viewController = AddTagsConfirmationVC(self, transaction: transaction, tags: tags)
      view.window?.contentViewController = .navigation(self, to: viewController)
    default:
      break
    }
    createTagsViewController = CreateTagsVC(self)
    createTagsAlert = NSAlert.createTags(self)
  }
}

// MARK: - NSToolbarDelegate

extension AddTagsTagSelectionVC: NSToolbarDelegate {
  func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
    switch itemIdentifier {
    case .backButton:
      return .backButton(self, title: transaction.attributes.description, action: #selector(goBack))
    case .createTag:
      return .createTag(self, action: #selector(createTag))
    case .next:
      return .next(self, action: #selector(next))
    case .flexibleSpace:
      return NSToolbarItem(itemIdentifier: itemIdentifier)
    case .selectTagsSearch:
      return NSSearchToolbarItem(itemIdentifier: itemIdentifier, searchField: searchField)
    default:
      return nil
    }
  }
  
  func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return [.backButton, .createTag, .next, .flexibleSpace, .selectTagsSearch]
  }
  
  func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return toolbarDefaultItemIdentifiers(toolbar)
  }
}

// MARK: - NSToolbarItemValidation

extension AddTagsTagSelectionVC: NSToolbarItemValidation {
  @discardableResult func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
    switch item.itemIdentifier {
    case .createTag:
      if collectionView.selectionIndexPaths.isEmpty {
        item.toolTip = "Create new tags."
      } else {
        item.toolTip = "You must deselect all tags before creating new tags."
      }
      return collectionView.selectionIndexPaths.isEmpty
    case .next:
      if collectionView.selectionIndexPaths.isEmpty {
        item.toolTip = "You must select a tag in order to proceed."
      } else if collectionView.selectionIndexPaths.count > 6 {
        item.toolTip = "You can only select a maximum of 6 tags."
      } else {
        item.toolTip = "Confirm selection."
      }
      return !collectionView.selectionIndexPaths.isEmpty && collectionView.selectionIndexPaths.count <= 6
    default:
      return true
    }
  }
}

// MARK: - DoubleClickDelegate

extension AddTagsTagSelectionVC: DoubleClickDelegate {
  func didDoubleClick(indexPath: IndexPath) {
    let tag = filteredTags[indexPath.item]
    let viewController = AddTagsConfirmationVC(self, transaction: transaction, tag: tag)
    view.window?.contentViewController = .navigation(self, to: viewController)
  }
}

// MARK: - NSSearchFieldDelegate

extension AddTagsTagSelectionVC: NSSearchFieldDelegate {
  func controlTextDidChange(_ obj: Notification) {
    applySnapshot()
  }
}

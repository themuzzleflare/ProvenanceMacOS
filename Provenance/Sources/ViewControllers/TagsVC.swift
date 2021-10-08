import Cocoa
import Alamofire

final class TagsVC: NSViewController {
  @IBOutlet weak var searchField: NSSearchField!
  
  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(TagItem.nib, forItemWithIdentifier: TagItem.reuseIdentifier)
      collectionView.collectionViewLayout = .listLayout
      collectionView.backgroundViewScrollsWithContent = true
    }
  }
  
  private enum Section {
    case main
  }
  
  private typealias DataSource = NSCollectionViewDiffableDataSource<Section, TagCellModel>
  
  private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TagCellModel>
  
  private lazy var dataSource = makeDataSource()
  
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
    fetchTags()
  }
  
  private func configureObservers() {
    apiKeyObserver = ProvenanceApp.userDefaults.observe(\.apiKey, options: .new) { [weak self] (_, _) in
      guard let weakSelf = self else { return }
      weakSelf.fetchTags()
    }
  }
  
  private func removeObservers() {
    apiKeyObserver?.invalidate()
    apiKeyObserver = nil
  }
  
  private func makeDataSource() -> DataSource {
    return DataSource(
      collectionView: collectionView,
      itemProvider: { (collectionView, indexPath, tag) in
        guard let item = collectionView.makeItem(withIdentifier: TagItem.reuseIdentifier, for: indexPath) as? TagItem else { fatalError() }
        item.tag = tag
        return item
      }
    )
  }
  
  private func applySnapshot(animate: Bool = true) {
    var snapshot = Snapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(filteredTags.tagCellModels, toSection: .main)
    
    if filteredTags.isEmpty && tagsError.isEmpty {
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
}

  // MARK: - NSCollectionViewDelegate

extension TagsVC: NSCollectionViewDelegate {
  func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    collectionView.deselectItems(at: indexPaths)
  }
}

  // MARK: - NSSearchFieldDelegate

extension TagsVC: NSSearchFieldDelegate {
  func controlTextDidChange(_ obj: Notification) {
    applySnapshot()
  }
}

import Cocoa
import Alamofire

final class CategoriesVC: NSViewController {
  @IBOutlet weak var searchField: NSSearchField!
  
  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.dataSource = dataSource
      collectionView.register(CategoryItem.nib, forItemWithIdentifier: CategoryItem.reuseIdentifier)
      collectionView.collectionViewLayout = .twoColumnGridLayout
      collectionView.backgroundViewScrollsWithContent = true
    }
  }
  
  @IBOutlet weak var categoryTypeSegmentedControl: NSSegmentedControl! {
    didSet {
      categoryTypeSegmentedControl.selectSegment(withTag: categoryFilter.rawValue)
    }
  }
  
  @IBAction func categoryTypeAction(_ sender: NSSegmentedControl) {
    if let value = CategoryTypeEnum(rawValue: sender.selectedSegment) {
      categoryFilter = value
    }
    if !searchField.stringValue.isEmpty {
      applySnapshot()
    }
  }
  
  private enum Section {
    case main
  }
  
  private typealias DataSource = NSCollectionViewDiffableDataSource<Section, CategoryCellModel>
  
  private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CategoryCellModel>
  
  private lazy var dataSource = makeDataSource()
  
  private var categoryFilter: CategoryTypeEnum = ProvenanceApp.userDefaults.appCategoryFilter {
    didSet {
      if ProvenanceApp.userDefaults.categoryFilter != categoryFilter.rawValue {
        ProvenanceApp.userDefaults.categoryFilter = categoryFilter.rawValue
      }
      if categoryTypeSegmentedControl.selectedSegment != categoryFilter.rawValue {
        categoryTypeSegmentedControl.selectSegment(withTag: categoryFilter.rawValue)
      }
    }
  }
  
  private var apiKeyObserver: NSKeyValueObservation?
  
  private var categoryFilterObserver: NSKeyValueObservation?
  
  private var noCategories: Bool = false
  
  private var categories = [CategoryResource]() {
    didSet {
      noCategories = categories.isEmpty
      applySnapshot()
      searchField.placeholderString = categories.searchFieldPlaceholder
    }
  }
  
  private var categoriesError = String()
  
  private var filteredCategories: [CategoryResource] {
    return categories.filtered(filter: categoryFilter, searchField: searchField)
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
    fetchCategories()
  }
  
  private func configureObservers() {
    apiKeyObserver = ProvenanceApp.userDefaults.observe(\.apiKey, options: .new) { [weak self] (_, _) in
      guard let weakSelf = self else { return }
      weakSelf.fetchCategories()
    }
    categoryFilterObserver = ProvenanceApp.userDefaults.observe(\.categoryFilter, options: .new) { [weak self] (_, change) in
      guard let weakSelf = self, let value = change.newValue, let categoryFilter = CategoryTypeEnum(rawValue: value) else { return }
      weakSelf.categoryFilter = categoryFilter
    }
  }
  
  private func removeObservers() {
    apiKeyObserver?.invalidate()
    apiKeyObserver = nil
    categoryFilterObserver?.invalidate()
    categoryFilterObserver = nil
  }
  
  private func makeDataSource() -> DataSource {
    return DataSource(
      collectionView: collectionView,
      itemProvider: { (collectionView, indexPath, category) in
        guard let item = collectionView.makeItem(withIdentifier: CategoryItem.reuseIdentifier, for: indexPath) as? CategoryItem else { fatalError() }
        item.category = category
        return item
      }
    )
  }
  
  private func applySnapshot(animate: Bool = true) {
    var snapshot = Snapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(filteredCategories.categoryCellModels, toSection: .main)
    
    if filteredCategories.isEmpty && categoriesError.isEmpty {
      if categories.isEmpty && !noCategories {
        collectionView.backgroundView = .loadingView(frame: collectionView.bounds, contentType: .categories)
      } else {
        collectionView.backgroundView = .noContentView(frame: collectionView.bounds, type: .categories)
      }
    } else {
      if !categoriesError.isEmpty {
        collectionView.backgroundView = .errorView(frame: collectionView.bounds, text: categoriesError)
      } else {
        if collectionView.backgroundView != nil {
          collectionView.backgroundView = nil
        }
      }
    }
    
    dataSource.apply(snapshot, animatingDifferences: animate)
  }
  
  private func fetchCategories() {
    UpFacade.listCategories { (result) in
      DispatchQueue.main.async {
        switch result {
        case let .success(categories):
          self.display(categories)
        case let .failure(error):
          self.display(error)
        }
      }
    }
  }
  
  private func display(_ categories: [CategoryResource]) {
    categoriesError = .emptyString
    self.categories = categories
  }
  
  private func display(_ error: AFError) {
    categoriesError = error.errorDescription ?? error.localizedDescription
    categories.removeAll()
  }
}

  // MARK: - NSCollectionViewDelegate

extension CategoriesVC: NSCollectionViewDelegate {
  func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    collectionView.deselectItems(at: indexPaths)
  }
}

  // MARK: - NSSearchFieldDelegate

extension CategoriesVC: NSSearchFieldDelegate {
  func controlTextDidChange(_ obj: Notification) {
    applySnapshot()
  }
  
  func searchFieldDidStartSearching(_ sender: NSSearchField) {
    categoryTypeSegmentedControl.isHidden = false
  }
  
  func searchFieldDidEndSearching(_ sender: NSSearchField) {
    categoryTypeSegmentedControl.isHidden = true
  }
}

import Cocoa

final class CategoryItem: CollectionViewItem {
  var category: CategoryCellModel? {
    didSet {
      guard isViewLoaded else { return }
      if let category = category {
        textField?.stringValue = category.name
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  private func configureView() {
    view.layer?.cornerRadius = 10.0
  }
}

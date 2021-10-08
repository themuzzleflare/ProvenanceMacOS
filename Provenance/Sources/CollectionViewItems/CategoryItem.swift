import Cocoa

final class CategoryItem: NSCollectionViewItem {
  static let reuseIdentifier = NSUserInterfaceItemIdentifier("categoryItem")
  static let nib = NSNib(nibNamed: "CategoryItem", bundle: nil)
  
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
  
  override var highlightState: NSCollectionViewItem.HighlightState {
    didSet {
      updateSelectionHighlighting()
    }
  }
  
  override var isSelected: Bool {
    didSet {
      updateSelectionHighlighting()
    }
  }
  
  private func configureView() {
    view.wantsLayer = true
    view.layer?.borderColor = .separator
    view.layer?.borderWidth = 0.5
  }
  
  private func updateSelectionHighlighting() {
    if !isViewLoaded { return }
    let showAsHighlighted = (highlightState == .forSelection) ||
    (isSelected && highlightState != .forDeselection) ||
    (highlightState == .asDropTarget)
    view.layer?.backgroundColor = showAsHighlighted ? .selected : nil
  }
}

import Cocoa

final class TagItem: NSCollectionViewItem {
  static let reuseIdentifier = NSUserInterfaceItemIdentifier("tagItem")
  static let nib = NSNib(nibNamed: "TagItem", bundle: nil)
  
  var tag: TagCellModel? {
    didSet {
      guard isViewLoaded else { return }
      if let tag = tag {
        textField?.stringValue = tag.id
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

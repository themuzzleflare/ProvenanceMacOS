import Cocoa

class CollectionViewItem: NSCollectionViewItem {
  var showAsHighlighted: Bool {
    return (highlightState == .forSelection) || (isSelected && highlightState != .forDeselection) || (highlightState == .asDropTarget)
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  private func configureView() {
    view.wantsLayer = true
    view.layer?.borderWidth = 0.25
  }
  
  func updateSelectionHighlighting() {
    guard isViewLoaded else { return }
    textField?.textColor = showAsHighlighted ? .selectedControlTextColor : .labelColor
    view.effectiveAppearance.performAsCurrentDrawingAppearance {
      view.layer?.backgroundColor = showAsHighlighted ? .selectedControl : nil
    }
  }
}

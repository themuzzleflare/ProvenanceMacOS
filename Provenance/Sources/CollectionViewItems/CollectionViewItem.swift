import Cocoa

class CollectionViewItem: NSCollectionViewItem {
  var showAsHighlighted: Bool {
    return (highlightState == .forSelection) ||
    (isSelected && highlightState != .forDeselection) ||
    (highlightState == .asDropTarget)
  }
  
  override var highlightState: NSCollectionViewItem.HighlightState {
    didSet {
      print("highlightState changed to: \(highlightState.description)")
      updateSelectionHighlighting()
    }
  }
  
  override var isSelected: Bool {
    didSet {
      print("isSelected changed to \(isSelected.description)")
      updateSelectionHighlighting()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  private func configureView() {
    view.wantsLayer = true
    view.layerContentsRedrawPolicy = .onSetNeedsDisplay
    view.layer?.borderWidth = 0.25
  }
  
  func updateSelectionHighlighting() {
    guard isViewLoaded else { return }
    let animation = CABasicAnimation(keyPath: "backgroundColor")
    animation.fromValue = view.layer?.backgroundColor
    animation.toValue = showAsHighlighted && highlightState != .asDropTarget ? CGColor.selectedControl : nil
    animation.duration = 0.1
    view.layer?.add(animation, forKey: animation.keyPath)
    textField?.animator().textColor = showAsHighlighted ? .selectedTextColor : .labelColor
    view.animator().effectiveAppearance.performAsCurrentDrawingAppearance {
      view.animator().layer?.backgroundColor = showAsHighlighted && highlightState != .asDropTarget ? .selectedControl : nil
      view.animator().layer?.borderColor = highlightState == .asDropTarget ? .selectedControl : .separator
      view.animator().layer?.borderWidth = highlightState == .asDropTarget ? 2.0 : 0.25
    }
  }
}

// MARK: - NSMenuDelegate

extension CollectionViewItem: NSMenuDelegate {
  func menuWillOpen(_ menu: NSMenu) {
    highlightState = .asDropTarget
  }
  
  func menuDidClose(_ menu: NSMenu) {
    highlightState = .none
  }
}

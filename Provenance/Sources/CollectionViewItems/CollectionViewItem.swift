import Cocoa

class CollectionViewItem: NSCollectionViewItem {
  var showAsHighlighted: Bool {
    return (highlightState == .forSelection) ||
    (isSelected && highlightState != .forDeselection)
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
    view.wantsLayer = true
    view.layerContentsRedrawPolicy = .onSetNeedsDisplay
    view.layer?.borderWidth = 0.25
  }

  func updateSelectionHighlighting() {
    guard isViewLoaded else { return }
    textField?.textColor = showAsHighlighted ? .selectedTextColor : .labelColor
    view.effectiveAppearance.performAsCurrentDrawingAppearance {
      let animation = CABasicAnimation(keyPath: "backgroundColor",
                                       fromValue: view.layer?.backgroundColor,
                                       toValue: showAsHighlighted ? CGColor.selectedControl : nil,
                                       duration: 0.1)
      view.layer?.add(animation, forKey: animation.keyPath)
      view.layer?.backgroundColor = showAsHighlighted ? .selectedControl : nil
      view.layer?.borderColor = highlightState == .asDropTarget ? .selectedControl : .separator
      view.layer?.borderWidth = highlightState == .asDropTarget ? 2.0 : 0.25
    }
  }
}

// MARK: - NSMenuDelegate

extension CollectionViewItem: NSMenuDelegate {
  func menuWillOpen(_ menu: NSMenu) {
    highlightState = .asDropTarget
  }

  func menuDidClose(_ menu: NSMenu) {
    highlightState = .forDeselection
  }
}

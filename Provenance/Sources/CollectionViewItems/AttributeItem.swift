import Cocoa

final class AttributeItem: NSCollectionViewItem {
  @IBOutlet weak var leftLabel: NSTextField!
  @IBOutlet weak var rightLabel: NSTextField!
  
  static let reuseIdentifier = NSUserInterfaceItemIdentifier("attributeItem")
  static let nib = NSNib(nibNamed: "AttributeItem", bundle: nil)
  
  var attribute: DetailItem? {
    didSet {
      guard isViewLoaded else { return }
      if let attribute = attribute {
        leftLabel.stringValue = attribute.id
        rightLabel.stringValue = attribute.value
        rightLabel.font = attribute.valueFont
      }
    }
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
    view.layer?.borderColor = .separator
    view.layer?.borderWidth = 0.5
  }
  
  private func updateSelectionHighlighting() {
    if !isViewLoaded { return }
    let showAsHighlighted = (highlightState == .forSelection) ||
    (isSelected && highlightState != .forDeselection) ||
    (highlightState == .asDropTarget)
    textField?.textColor = showAsHighlighted ? .selectedControlTextColor : .labelColor
    view.layer?.backgroundColor = showAsHighlighted ? .selectedControl : nil
  }
}

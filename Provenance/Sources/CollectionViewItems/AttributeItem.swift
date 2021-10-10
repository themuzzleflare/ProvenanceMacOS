import Cocoa

final class AttributeItem: CollectionViewItem {
  @IBOutlet weak var leftLabel: NSTextField!
  @IBOutlet weak var rightLabel: NSTextField!
  
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
  
  override func updateSelectionHighlighting() {
    guard isViewLoaded else { return }
    super.updateSelectionHighlighting()
    leftLabel.textColor = showAsHighlighted ? .selectedControlTextColor : .labelColor
    rightLabel.textColor = showAsHighlighted ? .selectedControlTextColor : .secondaryLabelColor
  }
}

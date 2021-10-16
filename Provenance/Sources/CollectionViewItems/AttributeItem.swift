import Cocoa

final class AttributeItem: CollectionViewItem {
  @IBOutlet weak var leftLabel: NSTextField!
  @IBOutlet weak var rightLabel: NSTextField!
  
  @IBAction func copyAttribute(_ sender: NSMenuItem) {
    NSPasteboard.general.setString(rightLabel.stringValue, forType: .string)
  }
  
  var attribute: DetailItem? {
    didSet {
      guard isViewLoaded, let attribute = attribute else { return }
      leftLabel.stringValue = attribute.id
      rightLabel.stringValue = attribute.value
      rightLabel.font = attribute.valueFont
    }
  }
  
  override func updateSelectionHighlighting() {
    guard isViewLoaded else { return }
    super.updateSelectionHighlighting()
    leftLabel.textColor = showAsHighlighted ? .selectedControlTextColor : .labelColor
    rightLabel.textColor = showAsHighlighted ? .selectedControlTextColor : .secondaryLabelColor
  }
}

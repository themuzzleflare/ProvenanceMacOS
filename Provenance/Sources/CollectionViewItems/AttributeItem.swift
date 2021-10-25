import Cocoa

final class AttributeItem: CollectionViewItem {
  var attribute: DetailItem? {
    didSet {
      guard isViewLoaded, let attribute = attribute else { return }
      leftLabel.stringValue = attribute.id
      rightLabel.stringValue = attribute.value
      rightLabel.font = attribute.valueFont
    }
  }

  @IBOutlet weak var leftLabel: NSTextField!
  @IBOutlet weak var rightLabel: NSTextField!

  @IBAction func copyAttribute(_ sender: NSMenuItem) {
    NSPasteboard.general.setString(rightLabel.stringValue, forType: .string)
  }

  override func updateSelectionHighlighting() {
    guard isViewLoaded else { return }
    super.updateSelectionHighlighting()
    leftLabel.textColor = showAsHighlighted ? .selectedControlTextColor : .labelColor
    rightLabel.textColor = showAsHighlighted ? .selectedControlTextColor : .secondaryLabelColor
  }

  deinit {
    print("\(#function) \(String(describing: type(of: self)))")
  }
}

import Cocoa

final class TagItem: CollectionViewItem {
  @IBAction func copyTagName(_ sender: NSMenuItem) {
    NSPasteboard.general.setString(textField?.stringValue ?? .emptyString, forType: .string)
  }
  
  var tag: TagCellModel? {
    didSet {
      guard isViewLoaded else { return }
      if let tag = tag {
        textField?.stringValue = tag.id
      }
    }
  }
}

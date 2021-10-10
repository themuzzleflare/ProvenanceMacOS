import Cocoa

final class TagItem: CollectionViewItem {
  var tag: TagCellModel? {
    didSet {
      guard isViewLoaded else { return }
      if let tag = tag {
        textField?.stringValue = tag.id
      }
    }
  }
}

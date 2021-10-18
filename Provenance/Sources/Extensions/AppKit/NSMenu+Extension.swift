import AppKit

extension NSMenu {
  convenience init(title: String, items: [NSMenuItem]) {
    self.init(title: title)
    self.items = items
  }
  
  static func categoryMenu(_ target: NSViewController, filter: TransactionCategory, action: Selector) -> NSMenu {
    return NSMenu(
      title: "Category",
      items: .categoryMenuItems(target, filter: filter, action: action)
    )
  }
}

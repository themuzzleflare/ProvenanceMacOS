import AppKit

extension NSToolbarItem {
  convenience init(itemIdentifier: NSToolbarItem.Identifier, view: NSView?) {
    self.init(itemIdentifier: itemIdentifier)
    self.view = view
  }
  
  static func backButton(title: String, action: Selector) -> NSToolbarItem {
    let toolbarItem = NSToolbarItem(itemIdentifier: .backButton)
    toolbarItem.isNavigational = true
    toolbarItem.image = .chevronLeft
    toolbarItem.title = title
    toolbarItem.action = action
    return toolbarItem
  }
  
  static func transactionStatusIcon(status: TransactionStatusEnum, action: Selector) -> NSToolbarItem {
    let toolbarItem = NSToolbarItem(itemIdentifier: .transactionStatus)
    toolbarItem.image = status.nsImage
    toolbarItem.action = action
    return toolbarItem
  }
  
  static func settledOnlyButton(action: Selector) -> NSToolbarItem {
    let toolbarItem = NSToolbarItem(itemIdentifier: .settledOnly)
    toolbarItem.title = "Settled Only"
    toolbarItem.image = .checkmarkCircle
    toolbarItem.action = action
    return toolbarItem
  }
}

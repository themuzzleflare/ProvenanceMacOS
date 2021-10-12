import AppKit

extension NSToolbarItem {
  convenience init(itemIdentifier: NSToolbarItem.Identifier, view: NSView?) {
    self.init(itemIdentifier: itemIdentifier)
    self.view = view
  }
  
  static func backButton(_ target: NSViewController, title: String, action: Selector) -> NSToolbarItem {
    let toolbarItem = NSToolbarItem(itemIdentifier: .backButton)
    toolbarItem.isNavigational = true
    toolbarItem.image = .chevronLeft
    toolbarItem.title = title
    toolbarItem.visibilityPriority = .high
    toolbarItem.target = target
    toolbarItem.action = action
    return toolbarItem
  }
  
  static func transactionStatusIcon(_ target: NSViewController, status: TransactionStatusEnum, action: Selector) -> NSToolbarItem {
    let toolbarItem = NSToolbarItem(itemIdentifier: .transactionStatus)
    toolbarItem.image = status.nsImage
    toolbarItem.toolTip = status.description + "."
    toolbarItem.target = target
    toolbarItem.action = action
    return toolbarItem
  }
  
  static func settledOnlyButton(_ target: NSViewController, action: Selector) -> NSToolbarItem {
    let toolbarItem = NSToolbarItem(itemIdentifier: .settledOnly)
    toolbarItem.title = "Settled Only"
    toolbarItem.image = .checkmarkCircle.withSymbolConfiguration(.small)
    toolbarItem.toolTip = "Filter by settled transactions only."
    toolbarItem.target = target
    toolbarItem.action = action
    return toolbarItem
  }
}

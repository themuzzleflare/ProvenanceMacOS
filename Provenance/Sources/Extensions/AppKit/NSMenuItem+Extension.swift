import AppKit

extension NSMenuItem {
  static func categoryMenuItem(_ target: NSViewController, category: TransactionCategory, filter: TransactionCategory, action: Selector) -> NSMenuItem {
    let menuItem = NSMenuItem(title: category.description, action: action, keyEquivalent: .emptyString)
    menuItem.target = target
    menuItem.state = category == filter ? .on : .off
    return menuItem
  }
  
  static func settledOnlyMenuFormRepresentation(_ target: NSViewController, settledOnly: Bool, action: Selector) -> NSMenuItem {
    let menuItem = NSMenuItem(title: "Settled Only", action: action, keyEquivalent: .emptyString)
    menuItem.target = target
    menuItem.state = settledOnly ? .on : .off
    menuItem.offStateImage = .checkmarkCircle
    menuItem.onStateImage = .checkmarkCircleFill
    return menuItem
  }
  
  static func categoryMenuFormRepresentation(category: TransactionCategory, submenu: NSMenu) -> NSMenuItem {
    let menuItem = NSMenuItem(title: "Category", action: nil, keyEquivalent: .emptyString)
    menuItem.state = category == .all ? .off : .on
    menuItem.submenu = submenu
    menuItem.offStateImage = .trayFull
    menuItem.onStateImage = .trayFullFill
    return menuItem
  }
}

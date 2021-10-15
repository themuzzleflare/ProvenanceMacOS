import AppKit

extension NSMenuItem {
  static func categoryMenuItem(_ target: NSViewController, category: TransactionCategory, filter: TransactionCategory, action: Selector) -> NSMenuItem {
    let menuItem = NSMenuItem(title: category.description, action: action, keyEquivalent: .emptyString)
    menuItem.target = target
    menuItem.state = category == filter ? .on : .off
    return menuItem
  }
  
  static func settledOnlyMenuItem(_ target: NSViewController, settledOnly: Bool, action: Selector) -> NSMenuItem {
    let menuItem = NSMenuItem(title: "Settled Only", action: action, keyEquivalent: .emptyString)
    menuItem.target = target
    menuItem.onStateImage = .checkmarkCircleFill
    menuItem.offStateImage = .checkmarkCircle
    menuItem.state = settledOnly.controlState == menuItem.state ? .on : .off
    return menuItem
  }
  
  static func categoryMenuFormRepresentation(submenu: NSMenu) -> NSMenuItem {
    let menuItem = NSMenuItem(title: "Category", action: nil, keyEquivalent: .emptyString)
    menuItem.state = ProvenanceApp.userDefaults.appSelectedCategory == .all ? .off : .on
    menuItem.offStateImage = .trayFull
    menuItem.onStateImage = .trayFullFill
    menuItem.submenu = submenu
    return menuItem
  }
}

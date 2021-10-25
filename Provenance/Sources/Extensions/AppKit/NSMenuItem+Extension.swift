import AppKit

extension NSMenuItem {
  static func categoryMenuItem(_ target: NSViewController,
                               category: TransactionCategory,
                               filter: TransactionCategory,
                               action: Selector) -> NSMenuItem {
    let menuItem = NSMenuItem(title: category.description, action: action, keyEquivalent: "")
    menuItem.target = target
    menuItem.state = category == filter ? .on : .off
    menuItem.representedObject = category
    return menuItem
  }

  static func settledOnlyMenuFormRepresentation(_ target: NSViewController,
                                                filter: Bool,
                                                action: Selector) -> NSMenuItem {
    let menuItem = NSMenuItem(title: "Settled Only", action: action, keyEquivalent: "")
    menuItem.target = target
    menuItem.state = filter ? .on : .off
    menuItem.offStateImage = .checkmarkCircle
    menuItem.onStateImage = .checkmarkCircleFill
    return menuItem
  }

  static func categoryMenuFormRepresentation(category: TransactionCategory,
                                             submenu: NSMenu) -> NSMenuItem {
    let menuItem = NSMenuItem(title: "Category", action: nil, keyEquivalent: "")
    menuItem.state = category == .all ? .off : .on
    menuItem.submenu = submenu
    menuItem.offStateImage = .trayFull
    menuItem.onStateImage = .trayFullFill
    return menuItem
  }
}

extension Array where Element: NSMenuItem {
  static func categoryMenuItems(target: NSViewController,
                                filter: TransactionCategory,
                                action: Selector) -> [NSMenuItem] {
    return TransactionCategory.allCases.map { (category) in
      return .categoryMenuItem(target, category: category, filter: filter, action: action)
    }
  }
}

import AppKit

extension NSToolbarItem {
  static var loading: NSToolbarItem {
    let progressIndicator = NSProgressIndicator.loadingToolbarItemView
    return NSToolbarItem(itemIdentifier: .loading, view: progressIndicator)
  }

  convenience init(itemIdentifier: NSToolbarItem.Identifier, view: NSView?) {
    self.init(itemIdentifier: itemIdentifier)
    self.view = view
  }

  static func backButton(_ target: NSViewController, title: String, action: Selector) -> NSToolbarItem {
    let toolbarItem = NSToolbarItem(itemIdentifier: .backButton)
    toolbarItem.isNavigational = true
    toolbarItem.isBordered = true
    toolbarItem.visibilityPriority = .high
    toolbarItem.image = .chevronLeft
    toolbarItem.title = title
    toolbarItem.toolTip = title
    toolbarItem.target = target
    toolbarItem.action = action
    return toolbarItem
  }

  static func transactionStatusIcon(_ target: NSViewController, status: TransactionStatusEnum, action: Selector) -> NSToolbarItem {
    let toolbarItem = NSToolbarItem(itemIdentifier: .transactionStatus)
    toolbarItem.isBordered = true
    toolbarItem.image = status.nsImage.withSymbolConfiguration(.large)
    toolbarItem.toolTip = status.description
    toolbarItem.target = target
    toolbarItem.action = action
    return toolbarItem
  }

  static func settledOnlyButton(_ target: NSViewController, action: Selector, menuFormRepresentation: NSMenuItem) -> NSToolbarItem {
    let toolbarItem = NSToolbarItem(itemIdentifier: .settledOnly)
    toolbarItem.title = "Settled Only"
    toolbarItem.image = UserDefaults.provenance.settledOnly ? .checkmarkCircleFill.withSymbolConfiguration(.small) : .checkmarkCircle.withSymbolConfiguration(.small)
    toolbarItem.toolTip = "Filter by settled transactions only."
    toolbarItem.target = target
    toolbarItem.action = action
    toolbarItem.menuFormRepresentation = menuFormRepresentation
    return toolbarItem
  }

  static func categories(segmentedControl: NSSegmentedControl, menuFormRepresentation: NSMenuItem) -> NSToolbarItem {
    let toolbarItem = NSToolbarItem(itemIdentifier: .categoryFilter, view: segmentedControl)
    toolbarItem.label = "Category"
    toolbarItem.image = UserDefaults.provenance.appSelectedCategory == .all ? .trayFull : .trayFullFill
    toolbarItem.toolTip = "Filter by the selected category."
    toolbarItem.menuFormRepresentation = menuFormRepresentation
    return toolbarItem
  }

  static func addTags(_ target: NSViewController, action: Selector) -> NSToolbarItem {
    let toolbarItem = NSToolbarItem(itemIdentifier: .addTags)
    toolbarItem.isBordered = true
    toolbarItem.image = .plus
    toolbarItem.label = "Add"
    toolbarItem.toolTip = "Add tags."
    toolbarItem.target = target
    toolbarItem.action = action
    return toolbarItem
  }

  static func next(_ target: NSViewController, action: Selector) -> NSToolbarItem {
    let toolbarItem = NSToolbarItem(itemIdentifier: .next)
    toolbarItem.isBordered = true
    toolbarItem.visibilityPriority = .high
    toolbarItem.image = .chevronRight
    toolbarItem.label = "Next"
    toolbarItem.toolTip = "Confirm selection."
    toolbarItem.target = target
    toolbarItem.action = action
    return toolbarItem
  }

  static func createTag(_ target: NSViewController, action: Selector) -> NSToolbarItem {
    let toolbarItem = NSToolbarItem(itemIdentifier: .createTag)
    toolbarItem.isBordered = true
    toolbarItem.image = .plus
    toolbarItem.label = "Create"
    toolbarItem.toolTip = "Create new tags."
    toolbarItem.target = target
    toolbarItem.action = action
    return toolbarItem
  }

  static func confirm(_ target: NSViewController, action: Selector) -> NSToolbarItem {
    let toolbarItem = NSToolbarItem(itemIdentifier: .confirm)
    toolbarItem.isBordered = true
    toolbarItem.image = .checkmarkCircle
    toolbarItem.label = "Confirm"
    toolbarItem.toolTip = "Confirm operation."
    toolbarItem.target = target
    toolbarItem.action = action
    return toolbarItem
  }
}

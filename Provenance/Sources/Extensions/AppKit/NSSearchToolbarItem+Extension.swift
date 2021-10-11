import AppKit

extension NSSearchToolbarItem {
  convenience init(itemIdentifier: NSToolbarItem.Identifier, searchField: NSSearchField) {
    self.init(itemIdentifier: itemIdentifier)
    self.searchField = searchField
  }
}

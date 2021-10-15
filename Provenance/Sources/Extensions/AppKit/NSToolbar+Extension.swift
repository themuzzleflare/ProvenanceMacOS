import AppKit

extension NSToolbar {
  convenience init(_ delegate: NSToolbarDelegate, identifier: NSToolbar.Identifier) {
    self.init(identifier: identifier)
    self.delegate = delegate
    self.displayMode = .iconOnly
    self.allowsUserCustomization = false
  }
}

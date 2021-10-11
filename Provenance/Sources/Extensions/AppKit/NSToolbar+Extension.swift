import AppKit

extension NSToolbar {
  convenience init(_ delegate: NSToolbarDelegate, type: NSToolbar.Identifier) {
    self.init(identifier: type)
    self.delegate = delegate
    self.displayMode = .iconOnly
    self.allowsUserCustomization = false
  }
}

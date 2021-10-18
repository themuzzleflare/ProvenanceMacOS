import AppKit

extension NSTabViewItem {
  convenience init(identifier: String, viewController: NSViewController, label: String, image: NSImage?) {
    self.init(identifier: identifier)
    self.viewController = viewController
    self.label = label
    self.image = image
  }
}

import AppKit

extension NSTabViewItem {
  convenience init(identifier: String, viewController: NSViewController, label: String, image: NSImage?) {
    self.init(viewController: viewController)
    self.label = label
    self.image = image
    self.identifier = identifier
  }
}

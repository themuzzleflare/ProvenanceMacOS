import AppKit

extension NSTabViewItem {
  convenience init(viewController: NSViewController, label: String, image: NSImage?) {
    self.init(viewController: viewController)
    self.label = label
    self.image = image
  }
}

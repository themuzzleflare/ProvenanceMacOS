import AppKit

extension NSImageView {
  convenience init(image: NSImage, contentTintColor: NSColor?) {
    self.init(image: image)
    self.contentTintColor = contentTintColor
  }
}

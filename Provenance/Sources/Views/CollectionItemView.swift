import Cocoa

class CollectionItemView: NSView {
  override func updateLayer() {
    super.updateLayer()
    self.layer?.borderColor = .separator
  }
}

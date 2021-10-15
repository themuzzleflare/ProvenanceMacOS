import AppKit

extension NSProgressIndicator {
  convenience init(style: NSProgressIndicator.Style, controlSize: NSControl.ControlSize = .regular) {
    self.init()
    self.style = style
    self.controlSize = controlSize
  }
  
  static var loadingToolbarItemView: NSProgressIndicator {
    let progressIndicator = NSProgressIndicator(
      style: .spinning,
      controlSize: .small
    )
    progressIndicator.startAnimation(self)
    return progressIndicator
  }
}

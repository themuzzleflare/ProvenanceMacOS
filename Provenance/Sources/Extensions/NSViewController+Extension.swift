import AppKit

extension NSViewController {
  static func navigation(_ from: NSViewController, to viewController: NSViewController) -> NSViewController {
    viewController.view.setFrameOrigin(NSPoint(x: 0, y: 0))
    viewController.view.setFrameSize(from.view.frame.size)
    return viewController
  }
}

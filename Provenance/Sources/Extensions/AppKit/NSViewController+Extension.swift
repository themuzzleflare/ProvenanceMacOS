import AppKit

extension NSViewController {
  static func navigation(_ fromViewController: NSViewController, to toViewController: NSViewController) -> NSViewController {
    toViewController.view.setFrameOrigin(.zero)
    toViewController.view.setFrameSize(fromViewController.view.frame.size)
    return toViewController
  }
}

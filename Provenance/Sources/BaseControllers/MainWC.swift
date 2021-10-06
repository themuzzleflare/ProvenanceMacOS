import Cocoa

final class MainWC: NSWindowController {
  override func windowDidLoad() {
    super.windowDidLoad()
    if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
      appDelegate.windowController = self
    }
  }
}

extension MainWC: NSWindowRestoration {
  static func restoreWindow(withIdentifier identifier: NSUserInterfaceItemIdentifier, state: NSCoder, completionHandler: @escaping (NSWindow?, Error?) -> Void) {
    let identifier = identifier.rawValue
    var restoreWindow: NSWindow? = nil
    if identifier == "MainWindow" {
      if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
        restoreWindow = appDelegate.windowController?.window
      }
    }
    completionHandler(restoreWindow, nil)
  }
}

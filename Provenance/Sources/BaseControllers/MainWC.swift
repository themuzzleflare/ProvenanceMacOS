import Cocoa

final class MainWC: NSWindowController {
  override func windowDidLoad() {
    super.windowDidLoad()
    AppDelegate.windowController = self
  }
}

// MARK: - NSWindowRestoration

extension MainWC: NSWindowRestoration {
  static func restoreWindow(withIdentifier identifier: NSUserInterfaceItemIdentifier, state: NSCoder, completionHandler: @escaping (NSWindow?, Error?) -> Void) {
    var restoreWindow: NSWindow?
    if identifier.rawValue == "MainWindow" {
      restoreWindow = AppDelegate.windowController?.window
    }
    completionHandler(restoreWindow, nil)
  }
}

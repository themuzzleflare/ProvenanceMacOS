import Cocoa

final class MainWC: NSWindowController {
  @IBOutlet weak var backButton: NSToolbarItem!
  
  override func windowDidLoad() {
    super.windowDidLoad()
    AppDelegate.windowController = self
  }
}

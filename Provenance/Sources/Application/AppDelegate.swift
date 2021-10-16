import Cocoa
import SwiftDate

@main class AppDelegate: NSObject, NSApplicationDelegate {
  static var windowController: MainWC?
  
  @IBOutlet weak var transactionsMenuItem: NSMenuItem!
  @IBOutlet weak var accountsMenuItem: NSMenuItem!
  @IBOutlet weak var tagsMenuItem: NSMenuItem!
  @IBOutlet weak var categoriesMenuItem: NSMenuItem!
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    SwiftDate.defaultRegion = .current
    NSPasteboard.general.declareTypes([.string], owner: nil)
  }
  
  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if flag { return true }
    AppDelegate.windowController?.window?.makeKeyAndOrderFront(self)
    return false
  }
  
  func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}

import Cocoa
import SwiftDate

@main class AppDelegate: NSObject, NSApplicationDelegate {
  var windowController: MainWC?
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    SwiftDate.defaultRegion = .current
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
  }
  
  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if flag {
      return true
    }
    windowController?.window?.makeKeyAndOrderFront(self)
    return false
  }
  
  func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}

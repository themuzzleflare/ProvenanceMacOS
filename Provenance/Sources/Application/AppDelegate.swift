import Cocoa
import SwiftDate

@main class AppDelegate: NSObject, NSApplicationDelegate {
  static var windowController: MainWC?
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    SwiftDate.defaultRegion = .current
    NSPasteboard.general.declareTypes([.string], owner: nil)
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
  }
  
  func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  
  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}

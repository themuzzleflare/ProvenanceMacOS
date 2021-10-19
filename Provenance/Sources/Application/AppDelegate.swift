import Cocoa
import SwiftDate

@main class AppDelegate: NSObject, NSApplicationDelegate {
  static var windowController: MainWC?
  
  private var dateStyleObserver: NSKeyValueObservation?
  
  @IBOutlet weak var refreshMenuItem: NSMenuItem!
  @IBOutlet weak var transactionsMenuItem: NSMenuItem!
  @IBOutlet weak var accountsMenuItem: NSMenuItem!
  @IBOutlet weak var tagsMenuItem: NSMenuItem!
  @IBOutlet weak var categoriesMenuItem: NSMenuItem!
  
  @IBOutlet weak var absoluteDateStyleMenuItem: NSMenuItem! {
    didSet {
      absoluteDateStyleMenuItem.state = ProvenanceApp.userDefaults.appDateStyle == .absolute ? .on : .off
    }
  }
  
  @IBOutlet weak var relativeDateStyleMenuItem: NSMenuItem! {
    didSet {
      relativeDateStyleMenuItem.state = ProvenanceApp.userDefaults.appDateStyle == .relative ? .on : .off
    }
  }
  
  @IBAction func absoluteAction(_ sender: NSMenuItem) {
    ProvenanceApp.userDefaults.appDateStyle = .absolute
  }
  
  @IBAction func relativeAction(_ sender: NSMenuItem) {
    ProvenanceApp.userDefaults.appDateStyle = .relative
  }
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    SwiftDate.defaultRegion = .current
    NSPasteboard.general.declareTypes([.string], owner: nil)
    configureObserver()
  }
  
  func application(_ application: NSApplication, open urls: [URL]) {
    guard let url = urls.first?.absoluteString else { return }
    let accountId = url.replacingOccurrences(of: "provenance://accounts/", with: "")
    UpFacade.retrieveAccount(for: accountId) { (result) in
      switch result {
      case let .success(account):
        let viewController = TransactionsByAccountVC(account: account)
        application.mainWindow?.windowController?.contentViewController?.presentAsModalWindow(viewController)
      case .failure:
        break
      }
    }
  }
  
  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if flag { return true }
    AppDelegate.windowController?.window?.makeKeyAndOrderFront(self)
    return false
  }
  
  func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  
  private func configureObserver() {
    dateStyleObserver = ProvenanceApp.userDefaults.observe(\.dateStyle, options: .new) { [weak self] (_, change) in
      guard let weakSelf = self,
            let value = change.newValue,
            let dateStyleEnum = AppDateStyle(rawValue: value)
      else {
        return
      }
      switch dateStyleEnum {
      case .absolute:
        weakSelf.absoluteDateStyleMenuItem.state = .on
        weakSelf.relativeDateStyleMenuItem.state = .off
      case .relative:
        weakSelf.absoluteDateStyleMenuItem.state = .off
        weakSelf.relativeDateStyleMenuItem.state = .on
      }
    }
  }
}

import Cocoa
import SwiftDate

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  static var windowController: MainWC?

  private var dateStyleObserver: NSKeyValueObservation?

  private lazy var dateStyle: AppDateStyle = App.userDefaults.appDateStyle {
    didSet {
      if App.userDefaults.dateStyle != dateStyle.rawValue {
        App.userDefaults.dateStyle = dateStyle.rawValue
      }
      if oldValue.menuItem?.state != .off {
        oldValue.menuItem?.state = .off
      }
      if dateStyle.menuItem?.state != .on {
        dateStyle.menuItem?.state = .on
      }
    }
  }

  @IBOutlet weak var refreshMenuItem: NSMenuItem!
  @IBOutlet weak var transactionsMenuItem: NSMenuItem!
  @IBOutlet weak var accountsMenuItem: NSMenuItem!
  @IBOutlet weak var tagsMenuItem: NSMenuItem!
  @IBOutlet weak var categoriesMenuItem: NSMenuItem!

  @IBOutlet weak var absoluteDateStyleMenuItem: NSMenuItem! {
    didSet {
      absoluteDateStyleMenuItem.state = dateStyle == .absolute ? .on : .off
    }
  }

  @IBOutlet weak var relativeDateStyleMenuItem: NSMenuItem! {
    didSet {
      relativeDateStyleMenuItem.state = dateStyle == .relative ? .on : .off
    }
  }

  @IBAction func absoluteAction(_ sender: NSMenuItem) {
    dateStyle = .absolute
  }

  @IBAction func relativeAction(_ sender: NSMenuItem) {
    dateStyle = .relative
  }

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    SwiftDate.defaultRegion = .current
    NSPasteboard.general.declareTypes([.string], owner: nil)
    configureObserver()
  }

  func applicationWillTerminate(_ notification: Notification) {
    removeObserver()
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
    dateStyleObserver = App.userDefaults.observe(\.dateStyle, options: .new) { [weak self] (_, change) in
      guard let value = change.newValue, let dateStyleEnum = AppDateStyle(rawValue: value) else { return }
      self?.dateStyle = dateStyleEnum
    }
  }

  private func removeObserver() {
    dateStyleObserver?.invalidate()
    dateStyleObserver = nil
  }
}

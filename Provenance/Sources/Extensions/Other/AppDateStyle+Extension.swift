import AppKit

extension AppDateStyle {
  var menuItem: NSMenuItem? {
    guard let appDelegate = NSApp.delegate as? AppDelegate else { return nil }
    switch self {
    case .absolute:
      return appDelegate.absoluteDateStyleMenuItem
    case .relative:
      return appDelegate.relativeDateStyleMenuItem
    }
  }
}

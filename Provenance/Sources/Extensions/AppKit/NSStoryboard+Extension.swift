import AppKit

extension NSStoryboard {
  static var preferences: NSStoryboard {
    return NSStoryboard(name: "Preferences", bundle: nil)
  }
  
  static var tabController: NSStoryboard {
    return NSStoryboard(name: "TabController", bundle: nil)
  }
}

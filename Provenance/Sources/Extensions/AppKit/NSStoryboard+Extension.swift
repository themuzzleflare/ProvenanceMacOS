import AppKit

extension NSStoryboard {
  convenience init(name: NSStoryboard.Name) {
    self.init(name: name, bundle: nil)
  }
  
  static var preferences: NSStoryboard {
    return NSStoryboard(name: "Preferences")
  }
  
  static var tabController: NSStoryboard {
    return NSStoryboard(name: "TabController")
  }
}

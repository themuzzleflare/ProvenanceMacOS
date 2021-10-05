import AppKit

extension NSEdgeInsets {
    /// `NSEdgeInsets(top: 13, left: 16, bottom: 13, right: 16)`.
  static var cellNode: NSEdgeInsets {
    return NSEdgeInsets(top: 13, left: 16, bottom: 13, right: 16)
  }
  
    /// `NSEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)`.
  static var horizontalInset: NSEdgeInsets {
    return NSEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
  }
  
    /// `NSEdgeInsets(top: 13, left: 0, bottom: 13, right: 0)`.
  static var verticalInset: NSEdgeInsets {
    return NSEdgeInsets(top: 13, left: 0, bottom: 13, right: 0)
  }
  
    /// `NSEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)`.
  static var sectionHeader: NSEdgeInsets {
    return NSEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
  }
}

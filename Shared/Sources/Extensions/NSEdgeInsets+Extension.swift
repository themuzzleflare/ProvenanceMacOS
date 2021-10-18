import AppKit

extension NSEdgeInsets {
  /// `NSEdgeInsets(top: 13.0, left: 16.0, bottom: 13.0, right: 16.0)`.
  static var cellNode: NSEdgeInsets {
    return NSEdgeInsets(top: 13.0, left: 16.0, bottom: 13.0, right: 16.0)
  }
  
  /// `NSEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)`.
  static var horizontalInset: NSEdgeInsets {
    return NSEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
  }
  
  /// `NSEdgeInsets(top: 13.0, left: 0, bottom: 13.0, right: 0)`.
  static var verticalInset: NSEdgeInsets {
    return NSEdgeInsets(top: 13.0, left: 0, bottom: 13.0, right: 0)
  }
  
  /// `NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 0)`.
  static var sectionHeader: NSEdgeInsets {
    return NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 0)
  }
}

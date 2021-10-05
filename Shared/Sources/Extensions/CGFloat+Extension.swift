import AppKit

extension CGFloat {
    /// `NSScreen.main!.frame.width`.
  static var screenWidth: CGFloat {
    return NSScreen.main!.frame.width
  }
  
    /// `NSScreen.main!.frame.height`.
  static var screenHeight: CGFloat {
    return NSScreen.main!.frame.height
  }
  
    /// `NSFont.labelFontSize`.
  static var labelFontSize: CGFloat {
    return NSFont.labelFontSize
  }
  
    /// `NSFont.smallSystemFontSize`.
  static var smallSystemFontSize: CGFloat {
    return NSFont.smallSystemFontSize
  }
}

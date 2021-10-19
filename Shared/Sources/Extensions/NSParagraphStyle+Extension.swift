import AppKit

extension NSParagraphStyle {
  /// A left-aligned paragraph style.
  static var leftAligned: NSParagraphStyle {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .left
    return paragraphStyle
  }

  /// A centre-aligned paragraph style.
  static var centreAligned: NSParagraphStyle {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    return paragraphStyle
  }

  /// A right-aligned paragraph style.
  static var rightAligned: NSParagraphStyle {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .right
    return paragraphStyle
  }
}

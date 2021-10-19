import AppKit

extension NSFont {
  static func circularStdBook(size: CGFloat) -> NSFont {
    return NSFont(name: "CircularStd-Book", size: size)!
  }

  static func circularStdBookItalic(size: CGFloat) -> NSFont {
    return NSFont(name: "CircularStd-BookItalic", size: size)!
  }

  static func circularStdMedium(size: CGFloat) -> NSFont {
    return NSFont(name: "CircularStd-Medium", size: size)!
  }

  static func circularStdBold(size: CGFloat) -> NSFont {
    return NSFont(name: "CircularStd-Bold", size: size)!
  }

  static func sfMonoRegular(size: CGFloat) -> NSFont {
    return NSFont(name: "SFMono-Regular", size: size)!
  }
}

import SwiftUI

extension Font {
  static func circularStdBook(size: CGFloat) -> Font {
    return custom("CircularStd-Book", size: size)
  }

  static func circularStdBookItalic(size: CGFloat) -> Font {
    return custom("CircularStd-BookItalic", size: size)
  }

  static func circularStdMedium(size: CGFloat) -> Font {
    return custom("CircularStd-Medium", size: size)
  }

  static func circularStdBold(size: CGFloat) -> Font {
    return custom("CircularStd-Bold", size: size)
  }

  static func sfMonoRegular(size: CGFloat) -> Font {
    return custom("SFMono-Regular", size: size)
  }
}

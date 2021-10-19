import Foundation

/// An enumeration describing the date style used in the app.
enum AppDateStyle: Int, CaseIterable {
  /// Absolute.
  case absolute

  /// Relative.
  case relative
}

extension AppDateStyle {
  var description: String {
    switch self {
    case .absolute:
      return "Absolute"
    case .relative:
      return "Relative"
    }
  }

  var dateStyleEnum: DateStyleEnum {
    switch self {
    case .absolute:
      return .absolute
    case .relative:
      return .relative
    }
  }
}

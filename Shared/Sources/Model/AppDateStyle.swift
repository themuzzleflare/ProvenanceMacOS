import Foundation

  /// An enumeration describing the date style used in the app.
enum AppDateStyle: Int, CaseIterable {
    /// Absolute.
  case absolute = 0
  
    /// Relative.
  case relative = 1
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
  
  var dateStyle: DateStyle {
    switch self {
    case .absolute:
      return .absolute
    case .relative:
      return .relative
    }
  }
}

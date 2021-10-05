import AppKit
import SwiftDate

class ProvenanceApp {
  static let userDefaults = UserDefaults.provenance
  
  static func formatDate(for dateString: String, dateStyle: AppDateStyle) -> String {
    SwiftDate.defaultRegion = .current
    guard let date = dateString.toDate() else { return dateString }
    switch dateStyle {
    case .absolute:
      return date.toString(.dateTime(.short))
    case .relative:
      return date.toRelative()
    }
  }
}

import Foundation
import SwiftDate

typealias App = ProvenanceApp

enum ProvenanceApp {
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

import Foundation
import SwiftDate

typealias Utils = ProvenanceUtils

enum ProvenanceUtils {
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

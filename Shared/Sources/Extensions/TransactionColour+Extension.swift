import SwiftUI

extension TransactionColour {
  var nsColour: NSColor {
    switch self {
    case .primaryLabel, .unknown:
      return .labelColor
    case .green:
      return .greenColour
    }
  }
  
  var colour: Color {
    switch self {
    case .primaryLabel, .unknown:
      return .primary
    case .green:
      return .greenColour
    }
  }
}

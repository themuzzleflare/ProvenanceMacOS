import SwiftUI

enum TransactionStatusEnum: String, Codable {
  case held = "HELD"
  case settled = "SETTLED"
}

extension TransactionStatusEnum {
  var isSettled: Bool {
    switch self {
    case .held:
      return false
    case .settled:
      return true
    }
  }
  
  var description: String {
    switch self {
    case .held:
      return "Held"
    case .settled:
      return "Settled"
    }
  }
  
  var nsImage: NSImage {
    switch self {
    case .held:
      return .clock
    case .settled:
      return .checkmarkCircle
    }
  }
  
  var image: Image {
    switch self {
    case .held:
      return .clock
    case .settled:
      return .checkmarkCircle
    }
  }
  
  var nsColour: NSColor {
    switch self {
    case .held:
      return .yellow
    case .settled:
      return .green
    }
  }
  
  var colour: Color {
    switch self {
    case .held:
      return .yellow
    case .settled:
      return .green
    }
  }
  
  var statusEnum: StatusEnum {
    switch self {
    case .held:
      return .held
    case .settled:
      return .settled
    }
  }
}

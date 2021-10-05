import Foundation

enum TransactionAmountType: Int {
  case debit = 0
  case credit = 1
  case amount = 2
}

extension TransactionAmountType {
  var description: String {
    switch self {
    case .debit:
      return "Debit"
    case .credit:
      return "Credit"
    case .amount:
      return "Amount"
    }
  }
  
  var colour: TransactionColour {
    switch self {
    case .debit:
      return .primaryLabel
    case .credit:
      return .green
    case .amount:
      return .unknown
    }
  }
}

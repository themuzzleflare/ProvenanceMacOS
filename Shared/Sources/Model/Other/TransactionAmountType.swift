import Foundation

enum TransactionAmountType: Int {
  case debit
  case credit
  case amount
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

  var colour: TransactionColourEnum {
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

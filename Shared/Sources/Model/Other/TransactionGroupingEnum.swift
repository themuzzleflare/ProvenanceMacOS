import Foundation

enum TransactionGroupingEnum: Int, CaseIterable {
  case all
  case dates
  case transactions
}

extension TransactionGroupingEnum {
  var description: String {
    switch self {
    case .all:
      return "All"
    case .dates:
      return "Dates"
    case .transactions:
      return "Transactions"
    }
  }
}

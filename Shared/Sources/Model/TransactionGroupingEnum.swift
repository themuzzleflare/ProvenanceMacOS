import Foundation

enum TransactionGroupingEnum: Int, CaseIterable {
  case all = 0
  case dates = 1
  case transactions = 2
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

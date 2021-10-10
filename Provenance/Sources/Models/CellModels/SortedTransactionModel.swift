import Foundation

struct SortedTransactionModel: Identifiable {
  var id: Date
  var transactions: [TransactionCellModel]
}

  // MARK: - Hashable

extension SortedTransactionModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: SortedTransactionModel, rhs: SortedTransactionModel) -> Bool {
    lhs.id == rhs.id
  }
}

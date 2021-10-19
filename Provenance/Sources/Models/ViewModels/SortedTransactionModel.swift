import Foundation

struct SortedTransactionModel: Identifiable {
  let id: Date
  let transactions: [TransactionViewModel]
}

// MARK: - Hashable

extension SortedTransactionModel: Hashable {
  static func == (lhs: SortedTransactionModel, rhs: SortedTransactionModel) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

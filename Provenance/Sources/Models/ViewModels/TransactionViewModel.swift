import Foundation

struct TransactionViewModel: Identifiable {
  let id: String
  let transactionDescription: String
  let creationDate: String
  let amount: String
  let colour: TransactionColourEnum

  init(transaction: TransactionResource) {
    self.id = transaction.id
    self.transactionDescription = transaction.attributes.description
    self.creationDate = transaction.attributes.creationDate
    self.amount = transaction.attributes.amount.valueShort
    self.colour = transaction.attributes.amount.transactionType.colour
  }

  init(id: String, transactionDescription: String, creationDate: String, amount: String, colour: TransactionColourEnum) {
    self.id = id
    self.transactionDescription = transactionDescription
    self.creationDate = creationDate
    self.amount = amount
    self.colour = colour
  }
}

// MARK: - Hashable

extension TransactionViewModel: Hashable {
  static func == (lhs: TransactionViewModel, rhs: TransactionViewModel) -> Bool {
    lhs.id == rhs.id && lhs.creationDate == rhs.creationDate
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

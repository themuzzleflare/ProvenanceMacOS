import Foundation

struct TransactionCellModel: Identifiable {
  let id: String
  let transactionDescription: String
  let creationDate: String
  let amount: String
  let colour: TransactionColour
  
  init(transaction: TransactionResource) {
    self.id = transaction.id
    self.transactionDescription = transaction.attributes.description
    self.creationDate = transaction.attributes.creationDate
    self.amount = transaction.attributes.amount.valueShort
    self.colour = transaction.attributes.amount.transactionType.colour
  }
  
  init(id: String, transactionDescription: String, creationDate: String, amount: String, colour: TransactionColour) {
    self.id = id
    self.transactionDescription = transactionDescription
    self.creationDate = creationDate
    self.amount = amount
    self.colour = colour
  }
}

  // MARK: - Hashable

extension TransactionCellModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: TransactionCellModel, rhs: TransactionCellModel) -> Bool {
    lhs.id == rhs.id && lhs.creationDate == rhs.creationDate
  }
}

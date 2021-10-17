import Foundation
import IGListKit

final class TransactionCellModel {
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

// MARK: - ListDiffable

extension TransactionCellModel: ListDiffable {
  func diffIdentifier() -> NSObjectProtocol {
    return id as NSObjectProtocol
  }
  
  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    if self === object { return true }
    guard let object = object as? TransactionCellModel else { return false }
    return self.creationDate == object.creationDate
  }
}

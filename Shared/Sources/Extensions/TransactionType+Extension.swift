import Intents

extension TransactionType {
  convenience init(transaction: TransactionResource) {
    self.init(identifier: transaction.id, display: transaction.attributes.description, subtitle: [transaction.attributes.amount.valueShort, transaction.attributes.creationDate].joined(separator: ", "), image: nil)
    self.transactionDescription = transaction.attributes.description
    self.transactionCreationDate = transaction.attributes.creationDate
    self.transactionAmount = transaction.attributes.amount.valueShort
    self.transactionColour = transaction.attributes.amount.transactionType.colour
  }
}

extension Array where Element: TransactionType {
  var collection: INObjectCollection<TransactionType> {
    return INObjectCollection(items: self)
  }
}

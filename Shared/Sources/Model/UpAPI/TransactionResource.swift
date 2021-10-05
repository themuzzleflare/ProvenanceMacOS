import AppKit

struct TransactionResource: Codable, Identifiable {
    /// The type of this resource: `transactions`
  var type = "transactions"
  
    /// The unique identifier for this transaction.
  var id: String
  
  var attributes: TransactionAttribute
  
  var relationships: TransactionRelationship
  
  var links: SelfLink?
}

extension TransactionResource {
  func latestTransactionModel(configuration: DateStyleSelectionIntent) -> LatestTransactionModel {
    return LatestTransactionModel(
      id: self.id,
      description: self.attributes.description,
      creationDate: configuration.dateStyle.description(self),
      amount: self.attributes.amount.valueShort,
      colour: self.attributes.amount.transactionType.colour
    )
  }
  
  var transactionType: TransactionType {
    return TransactionType(transaction: self)
  }
  
  var tagsArray: [NSString] {
    return self.relationships.tags.data.map { (tag) in
      return tag.id.nsString
    }
  }
}

extension Array where Element == TransactionResource {
  func filtered(searchField: NSSearchField) -> [TransactionResource] {
    return self.filter { (transaction) in
      return searchField.stringValue.isEmpty || transaction.attributes.description.localizedStandardContains(searchField.stringValue)
    }
  }
  
  var searchFieldPlaceholder: String {
    return "Search \(self.count.description) \(self.count == 1 ? "Transaction" : "Transactions")"
  }
  
  var transactionTypes: [TransactionType] {
    return self.map { (transaction) in
      return transaction.transactionType
    }
  }
}

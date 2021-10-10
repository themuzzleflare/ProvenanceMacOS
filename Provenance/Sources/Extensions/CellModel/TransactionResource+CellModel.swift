import Foundation

extension TransactionResource {
  var transactionCellModel: TransactionCellModel {
    return TransactionCellModel(transaction: self)
  }
}

extension Array where Element == TransactionResource {
  var transactionCellModels: [TransactionCellModel] {
    return self.map { (transaction) in
      return transaction.transactionCellModel
    }
  }
  
  var sortedTransactionModels: [SortedTransactionModel] {
    return Dictionary(grouping: self, by: { $0.attributes.sortingDate }).sorted { $0.key > $1.key }.map { (section) in
      return SortedTransactionModel(id: section.key, transactions: section.value.transactionCellModels)
    }
  }
  
  var sortedTransactionCoreModels: [SortedTransactionCoreModel] {
    return Dictionary(grouping: self, by: { $0.attributes.sortingDate }).sorted { $0.key > $1.key }.map { (section) in
      return SortedTransactionCoreModel(id: section.key, transactions: section.value)
    }
  }
}

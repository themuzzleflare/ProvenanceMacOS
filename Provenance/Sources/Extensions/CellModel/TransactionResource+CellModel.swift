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
}

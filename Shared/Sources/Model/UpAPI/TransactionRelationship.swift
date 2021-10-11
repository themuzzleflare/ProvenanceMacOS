import Foundation

struct TransactionRelationship: Codable {
  var account: TransactionRelationshipAccount
  
  /// If this transaction is a transfer between accounts, this field will contain the account the transaction went to/came from. The `amount` field can be used to determine the direction of the transfer.
  var transferAccount: TransactionRelationshipTransferAccount
  
  var category: TransactionRelationshipCategory
  
  var parentCategory: TransactionRelationshipCategory
  
  var tags: TransactionRelationshipTag
}

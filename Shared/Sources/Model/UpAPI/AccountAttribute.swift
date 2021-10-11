import Foundation

struct AccountAttribute: Codable {
  /// The name associated with the account in the Up application.
  var displayName: String
  
  /// The bank account type of this account.
  var accountType: AccountTypeEnum
  
  /// The available balance of the account, taking into account any amounts that are currently on hold.
  var balance: MoneyObject
  
  /// The date-time at which this account was first opened.
  var createdAt: String
}

extension AccountAttribute {
  var creationDate: String {
    return ProvenanceApp.formatDate(for: createdAt, dateStyle: ProvenanceApp.userDefaults.appDateStyle)
  }
}

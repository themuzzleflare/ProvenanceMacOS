import AppKit

struct AccountResource: Codable, Identifiable {
  /// The type of this resource: `accounts`
  var type = "accounts"

  /// The unique identifier for this account.
  var id: String

  var attributes: AccountAttributes

  var relationships: AccountRelationships

  var links: SelfLink?
}

extension AccountResource {
  var accountBalanceModel: AccountBalanceModel {
    return AccountBalanceModel(
      id: self.id,
      displayName: self.attributes.displayName,
      balance: self.attributes.balance.valueShort
    )
  }

  var accountType: AccountType {
    return AccountType(
      identifier: self.id,
      display: self.attributes.displayName,
      subtitle: self.attributes.balance.valueShort,
      image: nil
    )
  }
}

extension Array where Element == AccountResource {
  var searchFieldPlaceholder: String {
    return "Search \(self.count.description) \(self.count == 1 ? "Account" : "Accounts")"
  }

  var accountTypes: [AccountType] {
    return self.map { (account) in
      return account.accountType
    }
  }

  func filtered(filter: AccountTypeOptionEnum,
                searchField: NSSearchField) -> [AccountResource] {
    return self.filter { (account) in
      return searchField.stringValue.isEmpty ||
      (account.attributes.displayName.localizedStandardContains(searchField.stringValue) &&
       account.attributes.accountType == filter.accountTypeEnum)
    }
  }
}

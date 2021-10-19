import Foundation

struct AccountViewModel: Identifiable {
  let id: String
  let balance: String
  let displayName: String

  init(account: AccountResource) {
    self.id = account.id
    self.balance = account.attributes.balance.valueShort
    self.displayName = account.attributes.displayName
  }

  init(id: String, balance: String, displayName: String) {
    self.id = id
    self.balance = balance
    self.displayName = displayName
  }
}

// MARK: - Hashable

extension AccountViewModel: Hashable {
  static func == (lhs: AccountViewModel, rhs: AccountViewModel) -> Bool {
    lhs.id == rhs.id && lhs.displayName == rhs.displayName && lhs.balance == rhs.balance
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

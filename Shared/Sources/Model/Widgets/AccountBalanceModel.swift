import Foundation

struct AccountBalanceModel: Identifiable {
  let id: String
  let displayName: String
  let balance: String
}

extension AccountBalanceModel {
  static var placeholder: AccountBalanceModel {
    return AccountBalanceModel(
      id: UUID().uuidString,
      displayName: "Up Account",
      balance: "$123.95"
    )
  }
}

import Foundation

enum AppWidgets: Int, CaseIterable {
  case accountBalance = 0
  case latestTransaction = 1
}

extension AppWidgets {
  var kind: String {
    switch self {
    case .accountBalance:
      return "accountBalanceWidget"
    case .latestTransaction:
      return "latestTransactionWidget"
    }
  }
  
  var name: String {
    switch self {
    case .accountBalance:
      return "Account Balance"
    case .latestTransaction:
      return "Latest Transaction"
    }
  }
  
  var description: String {
    switch self {
    case .accountBalance:
      return "Displays the balance of your selected account."
    case .latestTransaction:
      return "Displays your latest transaction."
    }
  }
}

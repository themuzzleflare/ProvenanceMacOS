import Foundation

extension AccountResource {
  var accountViewModel: AccountViewModel {
    return AccountViewModel(account: self)
  }
}

extension Array where Element == AccountResource {
  var accountViewModels: [AccountViewModel] {
    return self.map { (account) in
      return account.accountViewModel
    }
  }
}

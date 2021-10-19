import Foundation

extension AccountResource {
  var accountViewModel: AccountViewModel {
    return AccountViewModel(account: self)
  }

  var accountCellModel: AccountCellModel {
    return AccountCellModel(account: self)
  }
}

extension Array where Element == AccountResource {
  var accountViewModels: [AccountViewModel] {
    return self.map { (account) in
      return account.accountViewModel
    }
  }

  var accountCellModels: [AccountCellModel] {
    return self.map { (account) in
      return account.accountCellModel
    }
  }
}

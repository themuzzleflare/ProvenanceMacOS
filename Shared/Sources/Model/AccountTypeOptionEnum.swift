import Foundation

enum AccountTypeOptionEnum: Int, CaseIterable {
  case transactional = 0
  case saver = 1
}

extension AccountTypeOptionEnum {
  var description: String {
    switch self {
    case .transactional:
      return "Transactional"
    case .saver:
      return "Saver"
    }
  }
  
  var accountTypeEnum: AccountTypeEnum {
    switch self {
    case .transactional:
      return .transactional
    case .saver:
      return .saver
    }
  }
}

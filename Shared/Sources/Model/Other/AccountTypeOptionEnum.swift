import Foundation

enum AccountTypeOptionEnum: Int, CaseIterable {
  case transactional
  case saver
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

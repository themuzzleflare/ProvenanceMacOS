import Foundation

enum AccountTypeEnum: String, Codable {
  case saver = "SAVER"
  case transactional = "TRANSACTIONAL"
}

extension AccountTypeEnum {
  var accountTypeOptionEnum: AccountTypeOptionEnum {
    switch self {
    case .saver:
      return .saver
    case .transactional:
      return .transactional
    }
  }
}

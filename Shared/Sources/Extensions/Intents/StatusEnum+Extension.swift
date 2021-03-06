import Foundation

extension StatusEnum {
  var transactionStatusEnum: TransactionStatusEnum? {
    switch self {
    case .held:
      return .held
    case .settled:
      return .settled
    case .all, .unknown:
      return nil
    }
  }
}

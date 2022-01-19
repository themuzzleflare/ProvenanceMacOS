import Foundation

extension DateStyleEnum {
  var appDateStyle: AppDateStyle {
    switch self {
    case .absolute:
      return .absolute
    case .relative:
      return .relative
    case .appDefault, .unknown:
      return UserDefaults.provenance.appDateStyle
    }
  }

  func description(_ transaction: TransactionResource) -> String {
    switch self {
    case .absolute:
      return Utils.formatDate(for: transaction.attributes.createdAt, dateStyle: .absolute)
    case .relative:
      return Utils.formatDate(for: transaction.attributes.createdAt, dateStyle: .relative)
    case .appDefault, .unknown:
      return transaction.attributes.creationDate
    }
  }
}

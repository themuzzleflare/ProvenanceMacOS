import Foundation

extension DateStyleEnum {
  func description(_ transaction: TransactionResource) -> String {
    switch self {
    case .absolute:
      return ProvenanceApp.formatDate(for: transaction.attributes.createdAt, dateStyle: .absolute)
    case .relative:
      return ProvenanceApp.formatDate(for: transaction.attributes.createdAt, dateStyle: .relative)
    case .appDefault, .unknown:
      return transaction.attributes.creationDate
    }
  }
  
  var appDateStyle: AppDateStyle {
    switch self {
    case .absolute:
      return .absolute
    case .relative:
      return .relative
    case .appDefault, .unknown:
      return ProvenanceApp.userDefaults.appDateStyle
    }
  }
}

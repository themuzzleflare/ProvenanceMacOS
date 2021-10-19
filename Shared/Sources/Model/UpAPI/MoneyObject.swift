import Foundation

struct MoneyObject: Codable {
  /// The ISO 4217 currency code.
  var currencyCode: String

  /// The amount of money, formatted as a string in the relevant currency.
  /// For example, for an Australian dollar value of $10.56, this field will be `"10.56"`.
  /// The currency symbol is not included in the string.
  var value: String

  /// The amount of money in the smallest denomination for the currency, as a 64-bit integer.
  /// For example, for an Australian dollar value of $10.56, this field will be `1056`.
  var valueInBaseUnits: Int64
}

extension MoneyObject {
  var transactionType: TransactionAmountType {
    switch valueInBaseUnits.signum() {
    case -1:
      return .debit
    case 1:
      return .credit
    default:
      return .amount
    }
  }

  var valueShort: String {
    return NumberFormatter.currency(currencyCode: currencyCode).string(from: value.nsDecimalNumber) ?? value
  }

  var valueLong: String {
    return NumberFormatter.currencyLong(currencyCode: currencyCode).string(from: value.nsDecimalNumber) ?? value
  }
}

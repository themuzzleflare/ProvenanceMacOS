import Foundation

struct CashbackObject: Codable {
  /// A brief description of why this cashback was paid.
  var description: String
  
  /// The total amount of cashback paid, represented as a positive value.
  var amount: MoneyObject
}

import Foundation

struct RoundUpObject: Codable {
    /// The total amount of this Round Up, including any boosts, represented as a negative value.
  var amount: MoneyObject
  
    /// The portion of the Round Up `amount` owing to boosted Round Ups, represented as a negative value. If no boost was added to the Round Up this field will be `null`.
  var boostPortion: MoneyObject?
}

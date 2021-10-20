import Foundation

struct HoldInfoObject: Codable {
  /// The amount of this transaction while in the `HELD` status, in Australian dollars.
  var amount: MoneyObject

  /// The foreign currency amount of this transaction while in the `HELD` status.
  /// This field will be `null` for domestic transactions.
  /// The amount was converted to the AUD amount reflected in the `amount` field.
  var foreignAmount: MoneyObject?
}

import Foundation
import SwiftDate

struct TransactionAttribute: Codable {
  /// The current processing status of this transaction, according to whether or not this transaction has settled or is still held.
  var status: TransactionStatusEnum

  /// The original, unprocessed text of the transaction.
  /// This is often not a perfect indicator of the actual merchant, but it is useful for reconciliation purposes in some cases.
  var rawText: String?

  /// A short description for this transaction. Usually the merchant name for purchases.
  var description: String

  /// Attached message for this transaction, such as a payment message, or a transfer note.
  var message: String?

  /// If this transaction is currently in the `HELD` status, or was ever in the `HELD` status, the `amount` and `foreignAmount` of the transaction while `HELD`.
  var holdInfo: HoldInfoObject?

  /// Details of how this transaction was rounded-up. If no Round Up was applied this field will be `null`.
  var roundUp: RoundUpObject?

  /// If all or part of this transaction was instantly reimbursed in the form of cashback, details of the reimbursement.
  var cashback: CashbackObject?

  /// The amount of this transaction in Australian dollars.
  /// For transactions that were once `HELD` but are now `SETTLED`, refer to the `holdInfo` field for the original `amount` the transaction was `HELD` at.
  var amount: MoneyObject

  /// The foreign currency amount of this transaction.
  /// This field will be `null` for domestic transactions.
  /// The amount was converted to the AUD amount reflected in the `amount` of this transaction.
  /// Refer to the `holdInfo` field for the original `foreignAmount` the transaction was `HELD` at.
  var foreignAmount: MoneyObject?

  /// The date-time at which this transaction settled.
  /// This field will be `null` for transactions that are currently in the `HELD` status.
  var settledAt: String?

  /// The date-time at which this transaction was first encountered.
  var createdAt: String
}

extension TransactionAttribute {
  var createdAtDateComponents: DateComponents? {
    return createdAt.toDate()?.dateComponents
  }

  var settledAtDateComponents: DateComponents? {
    return settledAt?.toDate()?.dateComponents
  }

  var sortingDate: Date {
    return createdAt.toDate()?.dateAtStartOf(.day).date ?? Date()
  }

  var creationDate: String {
    return ProvenanceApp.formatDate(for: createdAt, dateStyle: ProvenanceApp.userDefaults.appDateStyle)
  }

  var settlementDate: String? {
    if let settledAt = settledAt {
      return ProvenanceApp.formatDate(for: settledAt, dateStyle: ProvenanceApp.userDefaults.appDateStyle)
    } else {
      return nil
    }
  }

  var holdValue: String {
    guard let holdInfo = holdInfo, holdInfo.amount.value != amount.value else { return .emptyString }
    return holdInfo.amount.valueLong
  }

  var holdForeignValue: String {
    guard let holdForeignAmount = holdInfo?.foreignAmount, holdForeignAmount.value != foreignAmount?.value else { return .emptyString }
    return holdForeignAmount.valueLong
  }

  var foreignValue: String {
    if let foreignAmount = foreignAmount {
      return foreignAmount.valueLong
    } else {
      return .emptyString
    }
  }
}

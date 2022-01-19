import Foundation

struct TransactionResponse: Codable {
  /// The transaction returned in this response.
  var data: TransactionResource
}

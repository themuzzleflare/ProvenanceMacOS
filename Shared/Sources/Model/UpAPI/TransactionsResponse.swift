import Foundation

struct TransactionsResponse: Codable {
  /// The list of transactions returned in this response.
  var data: [TransactionResource]

  var links: Pagination
}

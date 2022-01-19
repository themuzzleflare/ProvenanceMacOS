import Foundation

struct AccountsResponse: Codable {
  /// The list of accounts returned in this response.
  var data: [AccountResource]

  var links: Pagination
}

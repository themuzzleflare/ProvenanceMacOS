import Foundation

struct ErrorResponse: Codable {
  /// The list of errors returned in this response.
  var errors: [ErrorObject]
}

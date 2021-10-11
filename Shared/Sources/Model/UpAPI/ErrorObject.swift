import Foundation

struct ErrorObject: Codable {
  /// The HTTP status code associated with this error. This can also be obtained from the response headers. The status indicates the broad type of error according to HTTP semantics.
  var status: String
  
  /// A short description of this error. This should be stable across multiple occurrences of this type of error and typically expands on the reason for the status code.
  var title: String
  
  /// A detailed description of this error. This should be considered unique to individual occurrences of an error and subject to change. It is useful for debugging purposes.
  var detail: String
  
  /// If applicable, location in the request that this error relates to. This may be a parameter in the query string, or a an attribute in the request body.
  var source: ErrorSource?
}

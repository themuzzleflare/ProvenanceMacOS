import Foundation

struct ErrorSource: Codable {
    /// If this error relates to a query parameter, the name of the parameter.
  var parameter: String?
  
    /// If this error relates to an attribute in the request body, a rfc-6901 JSON pointer to the attribute.
  var pointer: String?
}

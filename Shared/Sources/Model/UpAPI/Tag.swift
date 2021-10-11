import Foundation

struct Tag: Codable {
  /// The list of tags returned in this response.
  var data: [TagResource]
  
  var links: Pagination
}

import Foundation

struct CategoriesResponse: Codable {
  /// The list of categories returned in this response.
  var data: [CategoryResource]
}

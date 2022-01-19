import Foundation

struct SelfRelatedLink: Codable {
  /// The link to retrieve or modify linkage between this resources and the related resource(s) in this relationship.
  var `self`: String

  /// The link to retrieve the related resource(s) in this relationship.
  var related: String?
}

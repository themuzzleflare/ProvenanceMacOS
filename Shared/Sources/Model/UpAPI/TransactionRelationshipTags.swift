import Foundation

struct TransactionRelationshipTags: Codable {
  var data: [RelationshipData]

  var links: SelfLink?
}

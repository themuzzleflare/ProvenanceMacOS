import Foundation

struct TransactionRelationshipTag: Codable {
  var data: [RelationshipData]
  
  var links: SelfLink?
}

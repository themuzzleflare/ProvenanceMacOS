import Foundation

struct CategoryRelationships: Codable {
  var parent: CategoryRelationshipParent

  var children: CategoryRelationshipChildren
}

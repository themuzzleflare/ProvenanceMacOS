import Foundation

struct CategoryRelationship: Codable {
  var parent: CategoryRelationshipParent
  
  var children: CategoryRelationshipChildren
}

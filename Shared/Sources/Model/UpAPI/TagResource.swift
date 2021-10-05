import Foundation
import AppKit

struct TagResource: Codable, Identifiable {
    /// The type of this resource: `tags`
  var type = "tags"
  
    /// The label of the tag, which also acts as the tag’s unique identifier.
  var id: String
  
  var relationships: TagRelationship?
}

extension TagResource {
  var relationshipData: RelationshipData {
    return RelationshipData(type: self.type, id: self.id)
  }
  
  var tagInputResourceIdentifier: TagInputResourceIdentifier {
    return TagInputResourceIdentifier(id: self.id)
  }
}

extension Array where Element == TagResource {
  static func singleTag(with tag: TagResource) -> [TagResource] {
    return [tag]
  }
  
  func filtered(searchField: NSSearchField) -> [TagResource] {
    return self.filter { (tag) in
      return searchField.stringValue.isEmpty || tag.id.localizedStandardContains(searchField.stringValue)
    }
  }
  
  var searchFieldPlaceholder: String {
    return "Search \(self.count.description) \(self.count == 1 ? "Tag" : "Tags")"
  }
  
  var nsStringArray: [NSString] {
    return self.map { (tag) in
      return tag.id.nsString
    }
  }
  
  var stringArray: [String] {
    return self.map { (tag) in
      return tag.id
    }
  }
  
  var joinedWithComma: String {
    return ListFormatter.localizedString(byJoining: stringArray)
  }
  
  var relationshipDatas: [RelationshipData] {
    return self.map { (tag) in
      return tag.relationshipData
    }
  }
  
  var tagInputResourceIdentifiers: [TagInputResourceIdentifier] {
    return self.map { (tag) in
      return tag.tagInputResourceIdentifier
    }
  }
}

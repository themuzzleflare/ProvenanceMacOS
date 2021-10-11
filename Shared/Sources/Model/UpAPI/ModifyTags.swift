import Foundation

struct ModifyTags: Codable {
  /// The tags to add to or remove from the transaction.
  var data: [TagInputResourceIdentifier]
  
  init(tags: [TagResource]) {
    self.data = tags.tagInputResourceIdentifiers
  }
  
  init(tag: TagResource) {
    self.data = .singleTag(with: tag.tagInputResourceIdentifier)
  }
  
  init(tags: [String]) {
    self.data = tags.tagInputResourceIdentifiers
  }
  
  init(tag: String) {
    self.data = .singleTag(with: tag.tagInputResourceIdentifier)
  }
}

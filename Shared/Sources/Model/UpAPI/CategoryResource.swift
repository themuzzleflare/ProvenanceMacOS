import AppKit

struct CategoryResource: Codable, Identifiable {
  /// The type of this resource: `categories`
  var type = "categories"
  
  /// The unique identifier for this category. This is a human-readable but URL-safe value.
  var id: String
  
  var attributes: CategoryAttribute
  
  var relationships: CategoryRelationship
  
  var links: SelfLink?
}

extension CategoryResource {
  var categoryTypeEnum: CategoryTypeEnum {
    return relationships.parent.data == nil ? .parent : .child
  }
  
  var categoryType: CategoryType {
    return CategoryType(
      identifier: self.id,
      display: self.attributes.name
    )
  }
}

extension Array where Element == CategoryResource {
  func filtered(filter: CategoryTypeEnum, searchField: NSSearchField) -> [CategoryResource] {
    return self.filter { (category) in
      return searchField.stringValue.isEmpty ||
      (category.attributes.name.localizedStandardContains(searchField.stringValue) && category.categoryTypeEnum == filter)
    }
  }
  
  var searchFieldPlaceholder: String {
    return "Search \(self.count.description) \(self.count == 1 ? "Category" : "Categories")"
  }
  
  var categoryTypes: [CategoryType] {
    return self.map { (category) in
      return category.categoryType
    }
  }
}

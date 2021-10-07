import Foundation

struct CategoryCellModel {
  let id: String
  let name: String
  
  init(category: CategoryResource) {
    self.id = category.id
    self.name = category.attributes.name
  }
  
  init(id: String, name: String) {
    self.id = id
    self.name = name
  }
}

  // MARK: - Hashable

extension CategoryCellModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: CategoryCellModel, rhs: CategoryCellModel) -> Bool {
    lhs.id == rhs.id && lhs.name == rhs.name
  }
}

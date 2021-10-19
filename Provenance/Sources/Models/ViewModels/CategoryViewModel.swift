import Foundation

struct CategoryViewModel: Identifiable {
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

extension CategoryViewModel: Hashable {
  static func == (lhs: CategoryViewModel, rhs: CategoryViewModel) -> Bool {
    lhs.id == rhs.id && lhs.name == rhs.name
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

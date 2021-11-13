import Foundation
import IGListKit

final class CategoryCellModel {
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

// MARK: - ListDiffable

extension CategoryCellModel: ListDiffable {
  func diffIdentifier() -> NSObjectProtocol {
    return id as NSObjectProtocol
  }

  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? CategoryCellModel else { return false }
    return self.name == object.name
  }
}

import Foundation

struct TagCellModel {
  let id: String
  
  init(tag: TagResource) {
    self.id = tag.id
  }
  
  init(id: String) {
    self.id = id
  }
}

  // MARK: - Hashable

extension TagCellModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: TagCellModel, rhs: TagCellModel) -> Bool {
    lhs.id == rhs.id
  }
}

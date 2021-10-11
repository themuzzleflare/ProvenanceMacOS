import Foundation

struct TagViewModel: Identifiable {
  let id: String
  
  init(tag: TagResource) {
    self.id = tag.id
  }
  
  init(id: String) {
    self.id = id
  }
}

// MARK: - Hashable

extension TagViewModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: TagViewModel, rhs: TagViewModel) -> Bool {
    lhs.id == rhs.id
  }
}

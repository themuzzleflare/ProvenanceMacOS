import Foundation

extension TagResource {
  var tagCellModel: TagCellModel {
    return TagCellModel(tag: self)
  }
}

extension Array where Element == TagResource {
  var tagCellModels: [TagCellModel] {
    return self.map { (tag) in
      return tag.tagCellModel
    }
  }
}

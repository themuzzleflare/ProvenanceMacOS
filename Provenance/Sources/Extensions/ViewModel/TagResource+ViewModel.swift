import Foundation

extension TagResource {
  var tagViewModel: TagViewModel {
    return TagViewModel(tag: self)
  }

  var tagCellModel: TagCellModel {
    return TagCellModel(tag: self)
  }
}

extension Array where Element == TagResource {
  var tagViewModels: [TagViewModel] {
    return self.map { (tag) in
      return tag.tagViewModel
    }
  }

  var tagCellModels: [TagCellModel] {
    return self.map { (tag) in
      return tag.tagCellModel
    }
  }
}

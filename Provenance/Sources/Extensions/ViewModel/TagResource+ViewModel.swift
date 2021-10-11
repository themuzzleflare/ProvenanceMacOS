import Foundation

extension TagResource {
  var tagViewModel: TagViewModel {
    return TagViewModel(tag: self)
  }
}

extension Array where Element == TagResource {
  var tagViewModels: [TagViewModel] {
    return self.map { (tag) in
      return tag.tagViewModel
    }
  }
}

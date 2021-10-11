import Foundation

extension CategoryResource {
  var categoryViewModel: CategoryViewModel {
    return CategoryViewModel(category: self)
  }
}

extension Array where Element == CategoryResource {
  var categoryViewModels: [CategoryViewModel] {
    return self.map { (category) in
      return category.categoryViewModel
    }
  }
}

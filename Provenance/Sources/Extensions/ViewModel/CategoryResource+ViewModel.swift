import Foundation

extension CategoryResource {
  var categoryViewModel: CategoryViewModel {
    return CategoryViewModel(category: self)
  }
  
  var categoryCellModel: CategoryCellModel {
    return CategoryCellModel(category: self)
  }
}

extension Array where Element == CategoryResource {
  var categoryViewModels: [CategoryViewModel] {
    return self.map { (category) in
      return category.categoryViewModel
    }
  }
  
  var categoryCellModels: [CategoryCellModel] {
    return self.map { (category) in
      return category.categoryCellModel
    }
  }
}

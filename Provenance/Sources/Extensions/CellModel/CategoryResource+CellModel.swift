import Foundation

extension CategoryResource {
  var categoryCellModel: CategoryCellModel {
    return CategoryCellModel(category: self)
  }
}

extension Array where Element == CategoryResource {
  var categoryCellModels: [CategoryCellModel] {
    return self.map { (category) in
      return category.categoryCellModel
    }
  }
}

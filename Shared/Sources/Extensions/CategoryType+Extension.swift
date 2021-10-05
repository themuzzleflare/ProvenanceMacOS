import Intents

extension Array where Element: CategoryType {
  var collection: INObjectCollection<CategoryType> {
    return INObjectCollection(items: self)
  }
}

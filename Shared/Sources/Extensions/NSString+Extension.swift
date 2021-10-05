import Intents

extension Array where Element: NSString {
  var collection: INObjectCollection<NSString> {
    return INObjectCollection(items: self)
  }
}

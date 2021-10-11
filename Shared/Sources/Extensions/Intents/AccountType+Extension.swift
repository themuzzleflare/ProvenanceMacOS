import Intents

extension Array where Element: AccountType {
  var collection: INObjectCollection<AccountType> {
    return INObjectCollection(items: self)
  }
}

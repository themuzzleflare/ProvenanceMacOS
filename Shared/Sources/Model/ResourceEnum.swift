import Foundation

enum ResourceEnum {
  case account(AccountResource)
  case category(CategoryResource)
  case tag(TagResource)
}

extension ResourceEnum {
  var windowTitle: String {
    switch self {
    case let .account(accountResource):
      return accountResource.attributes.displayName
    case let .category(categoryResource):
      return categoryResource.attributes.name
    case let .tag(tagResource):
      return tagResource.id
    }
  }
}

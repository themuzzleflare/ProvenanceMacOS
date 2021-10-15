import Foundation

enum ResourceEnum {
  case account(AccountResource)
  case tag(TagResource)
  case category(CategoryResource)
}

extension ResourceEnum {
  //  var accountResource: AccountResource {
  //
  //  }
  
  var description: String {
    switch self {
    case let .account(accountResource):
      return accountResource.attributes.displayName
    case let .tag(tagResource):
      return tagResource.id
    case let .category(categoryResource):
      return categoryResource.attributes.name
    }
  }
  
  var resourcEnumRaw: ResourceEnumRaw {
    switch self {
    case .account:
      return .account
    case .tag:
      return .tag
    case .category:
      return .category
    }
  }
}

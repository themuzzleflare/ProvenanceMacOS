import Foundation

enum ContentType: Int {
  case transactions = 0
  case accounts = 1
  case tags = 2
  case categories = 3
}

extension ContentType {
  var plural: String {
    switch self {
    case .transactions:
      return "Transactions"
    case .accounts:
      return "Accounts"
    case .tags:
      return "Tags"
    case .categories:
      return "Categories"
    }
  }
  
  var singular: String {
    switch self {
    case .transactions:
      return "Transaction"
    case .accounts:
      return "Account"
    case .tags:
      return "Tag"
    case .categories:
      return "Category"
    }
  }
  
  var noContentDescription: String {
    switch self {
    case .transactions:
      return "No Transactions"
    case .accounts:
      return "No Accounts"
    case .tags:
      return "No Tags"
    case .categories:
      return "No Categories"
    }
  }
  
  var loadingDescription: String {
    switch self {
    case .transactions:
      return "Loading Transactions"
    case .accounts:
      return "Loading Accounts"
    case .tags:
      return "Loading Tags"
    case .categories:
      return "Loading Categories"
    }
  }
  
  func searchBarPlaceholder(count: Int) -> String {
    return "Search \(count.description) \(count == 1 ? singular : plural)"
  }
}

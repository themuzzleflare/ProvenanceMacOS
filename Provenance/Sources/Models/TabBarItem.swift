import AppKit

enum TabBarItem: Int, CaseIterable {
  case transactions
  case accounts
  case tags
  case categories
}

extension TabBarItem {
  var identifier: String {
    switch self {
    case .transactions:
      return "transactionsTabViewItem"
    case .accounts:
      return "accountsTabViewItem"
    case .tags:
      return "tagsTabViewItem"
    case .categories:
      return "categoriesTabViewItem"
    }
  }
  
  var viewController: NSViewController {
    switch self {
    case .transactions:
      return TransactionsVC()
    case .accounts:
      return AccountsVC()
    case .tags:
      return TagsVC()
    case .categories:
      return CategoriesVC()
    }
  }
  
  var label: String {
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
  
  var image: NSImage? {
    switch self {
    case .transactions:
      return .dollarsignCircle
    case .accounts:
      return .walletPass
    case .tags:
      return .tag
    case .categories:
      return .trayFull
    }
  }
  
  var selectedImage: NSImage? {
    switch self {
    case .transactions:
      return .dollarsignCircleFill
    case .accounts:
      return .walletPassFill
    case .tags:
      return .tagFill
    case .categories:
      return .trayFullFill
    }
  }
  
  var tabViewItem: NSTabViewItem {
    return NSTabViewItem(
      identifier: self.identifier,
      viewController: self.viewController,
      label: self.label,
      image: self.image
    )
  }
}

extension Array where Element == TabBarItem {
  var tabViewItems: [NSTabViewItem] {
    return self.map { (item) in
      return item.tabViewItem
    }
  }
}

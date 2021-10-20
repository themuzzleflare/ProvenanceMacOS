import AppKit

enum TabBarItem: String, CaseIterable {
  case transactions = "transactionsTabViewItem"
  case accounts = "accountsTabViewItem"
  case tags = "tagsTabViewItem"
  case categories = "categoriesTabViewItem"
}

extension TabBarItem {
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

  var menuItem: NSMenuItem? {
    guard let appDelegate = NSApp.delegate as? AppDelegate else { return nil }
    switch self {
    case .transactions:
      return appDelegate.transactionsMenuItem
    case .accounts:
      return appDelegate.accountsMenuItem
    case .tags:
      return appDelegate.tagsMenuItem
    case .categories:
      return appDelegate.categoriesMenuItem
    }
  }

  var tabViewItem: NSTabViewItem {
    return NSTabViewItem(
      identifier: self.rawValue,
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

import AppKit

extension NSToolbarItem.Identifier {
  static var backButton: NSToolbarItem.Identifier {
    return NSToolbarItem.Identifier("backButton")
  }
  
  static var transactionsSearch: NSToolbarItem.Identifier {
    return NSToolbarItem.Identifier("transactionsSearch")
  }
  
  static var accountsSearch: NSToolbarItem.Identifier {
    return NSToolbarItem.Identifier("accountsSearch")
  }
  
  static var tagsSearch: NSToolbarItem.Identifier {
    return NSToolbarItem.Identifier("tagsSearch")
  }
  
  static var categoriesSearch: NSToolbarItem.Identifier {
    return NSToolbarItem.Identifier("categoriesSearch")
  }
  
  static var categoryFilter: NSToolbarItem.Identifier {
    return NSToolbarItem.Identifier("categoryFilter")
  }
  
  static var settledOnly: NSToolbarItem.Identifier {
    return NSToolbarItem.Identifier("settledOnly")
  }
  
  static var transactionStatus: NSToolbarItem.Identifier {
    return NSToolbarItem.Identifier("transactionStatus")
  }
}

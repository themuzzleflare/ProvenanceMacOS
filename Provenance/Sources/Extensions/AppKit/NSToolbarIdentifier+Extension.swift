import AppKit

extension NSToolbar.Identifier {
  static var transactions: NSToolbar.Identifier {
    return NSToolbar.Identifier("transactionsToolbar")
  }
  
  static var accounts: NSToolbar.Identifier {
    return NSToolbar.Identifier("accountsToolbar")
  }
  
  static var tags: NSToolbar.Identifier {
    return NSToolbar.Identifier("tagsToolbar")
  }
  
  static var categories: NSToolbar.Identifier {
    return NSToolbar.Identifier("categoriesToolbar")
  }
  
  static var filteredTransactions: NSToolbar.Identifier {
    return NSToolbar.Identifier("filteredTransactionsToolbar")
  }
  
  static var transactionDetail: NSToolbar.Identifier {
    return NSToolbar.Identifier("transactionDetailToolbar")
  }
}

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
  
  static var transactionTags: NSToolbar.Identifier {
    return NSToolbar.Identifier("transactionTagsToolbar")
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
  
  static var confirmation: NSToolbar.Identifier {
    return NSToolbar.Identifier("confirmationToolbar")
  }
  
  static var selectTransaction: NSToolbar.Identifier {
    return NSToolbar.Identifier("selectTransactionToolbar")
  }
  
  static var selectTags: NSToolbar.Identifier {
    return NSToolbar.Identifier("selectTagsToolbar")
  }
}

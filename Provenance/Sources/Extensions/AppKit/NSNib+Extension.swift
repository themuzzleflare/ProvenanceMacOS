import AppKit

extension NSNib {
  static var transactions: NSNib {
    return NSNib(nibNamed: "Transactions", bundle: nil)!
  }
  
  static var accounts: NSNib {
    return NSNib(nibNamed: "Accounts", bundle: nil)!
  }
  
  static var tags: NSNib {
    return NSNib(nibNamed: "Tags", bundle: nil)!
  }
  
  static var categories: NSNib {
    return NSNib(nibNamed: "Categories", bundle: nil)!
  }
  
  static var transactionItem: NSNib {
    return NSNib(nibNamed: "TransactionItem", bundle: nil)!
  }
  
  static var accountItem: NSNib {
    return NSNib(nibNamed: "AccountItem", bundle: nil)!
  }
  
  static var tagItem: NSNib {
    return NSNib(nibNamed: "TagItem", bundle: nil)!
  }
  
  static var categoryItem: NSNib {
    return NSNib(nibNamed: "CategoryItem", bundle: nil)!
  }
  
  static var attributeItem: NSNib {
    return NSNib(nibNamed: "AttributeItem", bundle: nil)!
  }
  
  static var transactionDetail: NSNib {
    return NSNib(nibNamed: "TransactionDetail", bundle: nil)!
  }
  
  static var transactionStatus: NSNib {
    return NSNib(nibNamed: "TransactionStatus", bundle: nil)!
  }
  
  static var filteredTransactions: NSNib {
    return NSNib(nibNamed: "FilteredTransactions", bundle: nil)!
  }
  
  static var dateSupplementaryView: NSNib {
    return NSNib(nibNamed: "DateSupplementaryView", bundle: nil)!
  }
}

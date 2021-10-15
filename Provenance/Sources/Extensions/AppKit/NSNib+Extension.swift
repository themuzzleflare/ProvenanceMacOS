import AppKit

extension NSNib {
  convenience init?(nibNamed nibName: NSNib.Name) {
    self.init(nibNamed: nibName, bundle: nil)
  }
  
  static var transactions: NSNib {
    return NSNib(nibNamed: "Transactions")!
  }
  
  static var accounts: NSNib {
    return NSNib(nibNamed: "Accounts")!
  }
  
  static var tags: NSNib {
    return NSNib(nibNamed: "Tags")!
  }
  
  static var categories: NSNib {
    return NSNib(nibNamed: "Categories")!
  }
  
  static var transactionItem: NSNib {
    return NSNib(nibNamed: "TransactionItem")!
  }
  
  static var accountItem: NSNib {
    return NSNib(nibNamed: "AccountItem")!
  }
  
  static var tagItem: NSNib {
    return NSNib(nibNamed: "TagItem")!
  }
  
  static var categoryItem: NSNib {
    return NSNib(nibNamed: "CategoryItem")!
  }
  
  static var attributeItem: NSNib {
    return NSNib(nibNamed: "AttributeItem")!
  }
  
  static var textItem: NSNib {
    return NSNib(nibNamed: "TextItem")!
  }
  
  static var transactionDetail: NSNib {
    return NSNib(nibNamed: "TransactionDetail")!
  }
  
  static var transactionStatus: NSNib {
    return NSNib(nibNamed: "TransactionStatus")!
  }
  
  static var filteredTransactions: NSNib {
    return NSNib(nibNamed: "FilteredTransactions")!
  }
  
  static var dateSupplementaryView: NSNib {
    return NSNib(nibNamed: "DateSupplementaryView")!
  }
  
  static var textSupplementaryView: NSNib {
    return NSNib(nibNamed: "TextSupplementaryView")!
  }
  
  static var addTagsTransactionSelection: NSNib {
    return NSNib(nibNamed: "AddTagsTransactionSelection")!
  }
  
  static var addTagsTagSelection: NSNib {
    return NSNib(nibNamed: "AddTagsTagSelection")!
  }
  
  static var addTagsConfirmation: NSNib {
    return NSNib(nibNamed: "AddTagsConfirmation")!
  }
  
  static var createTags: NSNib {
    return NSNib(nibNamed: "CreateTags")!
  }
  
  static var transactionTags: NSNib {
    return NSNib(nibNamed: "TransactionTags")!
  }
}

import AppKit

extension NSMenu {
  static func categoryMenu(_ target: NSViewController, filter: TransactionCategory, action: Selector) -> NSMenu {
    let categoryMenu = NSMenu(title: "CategoryMenu")
    TransactionCategory.allCases.forEach { (category) in
      categoryMenu.addItem(.categoryMenuItem(target, category: category, filter: filter, action: action))
    }
    return categoryMenu
  }
}

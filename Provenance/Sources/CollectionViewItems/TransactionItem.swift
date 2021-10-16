import Cocoa

final class TransactionItem: CollectionViewItem {
  @IBOutlet weak var transactionDescription: NSTextField!
  @IBOutlet weak var transactionCreationDate: NSTextField!
  @IBOutlet weak var transactionAmount: NSTextField!
  
  @IBAction func copyDescription(_ sender: NSMenuItem) {
    NSPasteboard.general.setString(transactionDescription.stringValue, forType: .string)
  }
  
  @IBAction func copyCreationDate(_ sender: NSMenuItem) {
    NSPasteboard.general.setString(transactionCreationDate.stringValue, forType: .string)
  }
  
  @IBAction func copyAmount(_ sender: NSMenuItem) {
    NSPasteboard.general.setString(transactionAmount.stringValue, forType: .string)
  }
  
  var transaction: TransactionViewModel? {
    didSet {
      guard isViewLoaded, let transaction = transaction else { return }
      transactionDescription.stringValue = transaction.transactionDescription
      transactionCreationDate.stringValue = transaction.creationDate
      transactionAmount.stringValue = transaction.amount
      transactionAmount.textColor = transaction.colour.nsColour
      configureMenu()
    }
  }
  
  override func updateSelectionHighlighting() {
    guard isViewLoaded else { return }
    super.updateSelectionHighlighting()
    transactionDescription.textColor = showAsHighlighted ? .selectedControlTextColor : .labelColor
    transactionCreationDate.textColor = showAsHighlighted ? .selectedControlTextColor : .secondaryLabelColor
    transactionAmount.textColor = showAsHighlighted ? .selectedControlTextColor : transaction?.colour.nsColour
  }
  
  private func configureMenu() {
    guard view.menu?.item(withTitle: "Remove") == nil, let viewController = collectionView?.delegate as? FilteredTransactionsVC, viewController.resource.resourcEnumRaw == .tag else { return }
    let menuItem = NSMenuItem(title: "Remove", action: #selector(removeTransaction), keyEquivalent: .emptyString)
    menuItem.image = .trash
    view.menu?.addItem(.separator())
    view.menu?.addItem(menuItem)
  }
  
  @objc private func removeTransaction() {
    guard let viewController = collectionView?.delegate as? FilteredTransactionsVC, case let .tag(tag) = viewController.resource, let indexPath = collectionView?.indexPath(for: self) else { return }
    let transaction = viewController.filteredTransactions[indexPath.item]
    let alert = NSAlert(
      alertStyle: .informational,
      icon: .tag,
      messageText: "Confirmation",
      informativeText: "Are you sure you want to remove \(tag.id) from \(transaction.attributes.description)?"
    )
    alert.addButton(withTitle: "Remove")
    alert.addButton(withTitle: "Cancel")
    switch alert.runModal() {
    case .alertFirstButtonReturn:
      UpFacade.modifyTags(removing: tag, from: transaction) { (error) in
        if let error = error {
          print(error.localizedDescription)
        } else {
          viewController.fetchingTasks()
        }
      }
    default:
      break
    }
  }
}

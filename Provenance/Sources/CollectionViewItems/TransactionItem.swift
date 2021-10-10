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
  
  var transaction: TransactionCellModel? {
    didSet {
      guard isViewLoaded else { return }
      if let transaction = transaction {
        transactionDescription.stringValue = transaction.transactionDescription
        transactionCreationDate.stringValue = transaction.creationDate
        transactionAmount.stringValue = transaction.amount
        transactionAmount.textColor = transaction.colour.nsColour
      }
    }
  }
  
  override func updateSelectionHighlighting() {
    guard isViewLoaded else { return }
    super.updateSelectionHighlighting()
    transactionDescription.textColor = showAsHighlighted ? .selectedControlTextColor : .labelColor
    transactionCreationDate.textColor = showAsHighlighted ? .selectedControlTextColor : .secondaryLabelColor
    transactionAmount.textColor = showAsHighlighted ? .selectedControlTextColor : transaction?.colour.nsColour
  }
}

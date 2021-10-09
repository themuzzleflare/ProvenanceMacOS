import Cocoa

final class TransactionItem: NSCollectionViewItem {
  @IBOutlet weak var transactionDescription: NSTextField!
  @IBOutlet weak var transactionCreationDate: NSTextField!
  @IBOutlet weak var transactionAmount: NSTextField!
  
  @IBAction func copyDescription(_ sender: NSMenuItem) {
    AppDelegate.pasteboard.setString(transactionDescription.stringValue, forType: .string)
  }
  @IBAction func copyCreationDate(_ sender: NSMenuItem) {
    AppDelegate.pasteboard.setString(transactionCreationDate.stringValue, forType: .string)
  }
  @IBAction func copyAmount(_ sender: NSMenuItem) {
    AppDelegate.pasteboard.setString(transactionAmount.stringValue, forType: .string)
  }
  
  static let reuseIdentifier = NSUserInterfaceItemIdentifier("transactionItem")
  static let nib = NSNib(nibNamed: "TransactionItem", bundle: nil)
  
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
  
  override var highlightState: NSCollectionViewItem.HighlightState {
    didSet {
      updateSelectionHighlighting()
    }
  }
  
  override var isSelected: Bool {
    didSet {
      updateSelectionHighlighting()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  private func configureView() {
    view.wantsLayer = true
    view.layer?.borderColor = .separator
    view.layer?.borderWidth = 0.5
  }
  
  private func updateSelectionHighlighting() {
    guard isViewLoaded else { return }
    let showAsHighlighted = (highlightState == .forSelection) || (isSelected && highlightState != .forDeselection) || (highlightState == .asDropTarget)
    view.layer?.backgroundColor = showAsHighlighted ? .selectedControl : nil
  }
}

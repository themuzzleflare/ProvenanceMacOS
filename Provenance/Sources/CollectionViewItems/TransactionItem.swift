import Cocoa

final class TransactionItem: NSCollectionViewItem {
  @IBOutlet weak var transactionDescription: NSTextField!
  @IBOutlet weak var transactionCreationDate: NSTextField!
  @IBOutlet weak var transactionAmount: NSTextField!
  
  static let reuseIdentifier = NSUserInterfaceItemIdentifier("transactionItem")
  static let nib = NSNib(nibNamed: "TransactionItem", bundle: nil)
  
  var transaction: TransactionCellModel? {
    didSet {
      guard isViewLoaded else { return }
      if let transaction = transaction {
        transactionDescription.stringValue = transaction.transactionDescription
        transactionCreationDate.stringValue = transaction.creationDate
        transactionAmount.textColor = transaction.colour.nsColour
        transactionAmount.stringValue = transaction.amount
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
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
  
  private func configureView() {
    view.wantsLayer = true
    view.layer?.borderColor = .separator
    view.layer?.borderWidth = 0.5
  }
  
  private func updateSelectionHighlighting() {
    if !isViewLoaded { return }
    let showAsHighlighted = (highlightState == .forSelection) ||
    (isSelected && highlightState != .forDeselection) ||
    (highlightState == .asDropTarget)
    view.layer?.backgroundColor = showAsHighlighted ? NSColor.selectedControlColor.cgColor : nil
  }
}

import Cocoa

final class AccountItem: NSCollectionViewItem {
  @IBOutlet weak var accountBalance: NSTextField!
  @IBOutlet weak var accountDisplayName: NSTextField!
  
  static let reuseIdentifier = NSUserInterfaceItemIdentifier("accountItem")
  static let nib = NSNib(nibNamed: "AccountItem", bundle: nil)
  
  var account: AccountCellModel? {
    didSet {
      guard isViewLoaded else { return }
      if let account = account {
        accountBalance.stringValue = account.balance
        accountDisplayName.stringValue = account.displayName
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
    view.layer?.backgroundColor = showAsHighlighted ? .selected : nil
  }
}

import Cocoa

final class AccountItem: CollectionViewItem {
  var account: AccountViewModel? {
    didSet {
      guard isViewLoaded, let account = account else { return }
      accountBalance.stringValue = account.balance
      accountDisplayName.stringValue = account.displayName
    }
  }

  @IBOutlet weak var accountBalance: NSTextField!
  @IBOutlet weak var accountDisplayName: NSTextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer?.cornerRadius = 10.0
  }

  @IBAction func copyBalance(_ sender: NSMenuItem) {
    NSPasteboard.general.setString(accountBalance.stringValue, forType: .string)
  }

  @IBAction func copyDisplayName(_ sender: NSMenuItem) {
    NSPasteboard.general.setString(accountDisplayName.stringValue, forType: .string)
  }

  override func updateSelectionHighlighting() {
    guard isViewLoaded else { return }
    super.updateSelectionHighlighting()
    accountBalance.textColor = showAsHighlighted ? .selectedControlTextColor : .accentColor
    accountDisplayName.textColor = showAsHighlighted ? .selectedControlTextColor : .labelColor
  }

  deinit {
    print("deinit AccountItem")
  }
}

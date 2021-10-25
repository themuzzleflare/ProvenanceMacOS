import Cocoa

final class TransactionStatusVC: NSViewController {
  override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: "TransactionStatus", bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  @IBAction func dismissAction(_ sender: NSButton) {
    dismiss(self)
  }

  deinit {
    print("\(#function) \(String(describing: type(of: self)))")
  }
}

import Cocoa

final class TransactionStatusVC: NSViewController {
  @IBAction func dismissAction(_ sender: NSButton) {
    dismiss(self)
  }
  
  override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: "TransactionStatus", bundle: nil)
  }
  
  deinit {
    print("deinit")
  }
  
  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }
}

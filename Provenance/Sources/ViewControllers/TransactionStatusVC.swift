import Cocoa

final class TransactionStatusVC: NSViewController {
  @IBAction func dismissAction(_ sender: NSButton) {
    dismiss(self)
  }
  
  override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: "TransactionStatus", bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

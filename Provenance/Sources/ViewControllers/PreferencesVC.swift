import Cocoa

final class PreferencesVC: NSViewController {
  @IBOutlet weak var apiKeyTextField: NSTextField! {
    didSet {
      apiKeyTextField.stringValue = ProvenanceApp.userDefaults.apiKey
    }
  }
  
  @IBOutlet weak var dateStylePopupButton: NSPopUpButton! {
    didSet {
      dateStylePopupButton.selectItem(at: ProvenanceApp.userDefaults.dateStyle)
    }
  }
  
  @IBAction func apiKeyAction(_ sender: NSTextField) {
    ProvenanceApp.userDefaults.apiKey = sender.stringValue
  }
  
  @IBAction func dateStyleAction(_ sender: NSPopUpButton) {
    ProvenanceApp.userDefaults.dateStyle = sender.indexOfSelectedItem
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

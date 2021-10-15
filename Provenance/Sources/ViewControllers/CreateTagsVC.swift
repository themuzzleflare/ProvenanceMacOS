import Cocoa

final class CreateTagsVC: NSViewController {
  @IBOutlet weak var textField1: NSTextField!
  @IBOutlet weak var textField2: NSTextField!
  @IBOutlet weak var textField3: NSTextField!
  @IBOutlet weak var textField4: NSTextField!
  @IBOutlet weak var textField5: NSTextField!
  @IBOutlet weak var textField6: NSTextField!
  
  private weak var alertViewController: AddTagsTagSelectionVC?
  
  var textFields: [NSTextField] {
    return [textField1, textField2, textField3, textField4, textField5, textField6]
  }
  
  init(_ target: AddTagsTagSelectionVC) {
    self.alertViewController = target
    super.init(nibName: "CreateTags", bundle: nil)
  }
  
  deinit {
    print("deinit CreateTagsVC")
  }
  
  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }
}

// MARK: - NSTextFieldDelegate

extension CreateTagsVC: NSTextFieldDelegate {
  func controlTextDidChange(_ obj: Notification) {
    if let nextButton = alertViewController?.createTagsAlert.buttons.first {
      let text = textFields.textsJoined
      nextButton.isEnabled = !text.isEmpty
    }
    guard let textField = obj.object as? NSTextField, textField.stringValue.count > 30 else { return }
    let newString = String(textField.stringValue.prefix(30))
    textField.stringValue = newString
  }
}

import AppKit
import Alamofire

extension NSAlert {
  convenience init(alertStyle: NSAlert.Style, icon: NSImage, messageText: String, informativeText: String) {
    self.init()
    self.alertStyle = alertStyle
    self.icon = icon
    self.messageText = messageText
    self.informativeText = informativeText
  }

  static func createTags(_ target: AddTagsTagSelectionVC) -> NSAlert {
    let alert = NSAlert(
      alertStyle: .informational,
      icon: .tag,
      messageText: "Create Tags",
      informativeText: "You can add a maximum of 6 tags to a transaction."
    )
    alert.accessoryView = target.createTagsViewController.view
    alert.addButton(withTitle: "Next").isEnabled = false
    alert.addButton(withTitle: "Cancel")
    return alert
  }

  static func tagsAddedSuccess(tags: [TagResource], transaction: TransactionResource) -> NSAlert {
    return NSAlert(
      alertStyle: .informational,
      icon: .tag,
      messageText: "Success",
      informativeText: "\(tags.joinedWithComma) \(tags.count == 1 ? "was" : "were") added to \(transaction.attributes.description)."
    )
  }

  static func tagsAddedFailure(error: AFError) -> NSAlert {
    return NSAlert(
      alertStyle: .warning,
      icon: .tagSlash,
      messageText: "Failed",
      informativeText: error.errorDescription ?? error.localizedDescription
    )
  }
}

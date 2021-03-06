import Cocoa

final class TagItem: CollectionViewItem {
  weak var delegate: DoubleClickDelegate?

  var tag: TagViewModel? {
    didSet {
      guard isViewLoaded, let tag = tag else { return }
      textField?.stringValue = tag.id
      configureMenu()
    }
  }

  @IBAction func copyTagName(_ sender: NSMenuItem) {
    NSPasteboard.general.setString(textField?.stringValue ?? "", forType: .string)
  }

  override func mouseDown(with event: NSEvent) {
    super.mouseDown(with: event)
    guard event.clickCount == 2, let delegate = delegate, let indexPath = collectionView?.indexPath(for: self) else { return }
    delegate.didDoubleClick(indexPath: indexPath)
  }

  private func configureMenu() {
    guard view.menu?.item(withTitle: "Remove") == nil, collectionView?.delegate is TransactionTagsVC else { return }
    let menuItem = NSMenuItem(title: "Remove", action: #selector(removeTag), keyEquivalent: "")
    menuItem.image = .trash
    view.menu?.addItem(.separator())
    view.menu?.addItem(menuItem)
  }

  @objc
  private func removeTag() {
    guard let viewController = collectionView?.delegate as? TransactionTagsVC,
          let indexPath = collectionView?.indexPath(for: self)
    else { return }
    let tag = viewController.tags[indexPath.item]
    let transaction = viewController.transaction
    let alert = NSAlert(
      alertStyle: .informational,
      icon: .tag,
      messageText: "Confirmation",
      informativeText: "Are you sure you want to remove \(tag.id) from \(transaction.attributes.description)?"
    )
    alert.addButton(withTitle: "Remove")
    alert.addButton(withTitle: "Cancel")
    switch alert.runModal() {
    case .alertFirstButtonReturn:
      Up.modifyTags(removing: tag, from: transaction) { (error) in
        if let error = error {
          print(error.localizedDescription)
        } else {
          viewController.fetchTransaction()
        }
      }
    default:
      break
    }
  }

  deinit {
    print("\(#function) \(String(describing: type(of: self)))")
  }
}

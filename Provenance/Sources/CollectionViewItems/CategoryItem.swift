import Cocoa

final class CategoryItem: CollectionViewItem {
  var category: CategoryViewModel? {
    didSet {
      guard isViewLoaded, let category = category else { return }
      textField?.stringValue = category.name
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer?.cornerRadius = 10.0
  }

  @IBAction func copyCategoryName(_ sender: NSMenuItem) {
    NSPasteboard.general.setString(textField?.stringValue ?? "", forType: .string)
  }

  deinit {
    print("\(#function) \(String(describing: type(of: self)))")
  }
}

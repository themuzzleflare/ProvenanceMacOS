import Cocoa

final class CategoryItem: CollectionViewItem {
  @IBAction func copyCategoryName(_ sender: NSMenuItem) {
    NSPasteboard.general.setString(textField?.stringValue ?? .emptyString, forType: .string)
  }
  
  var category: CategoryViewModel? {
    didSet {
      guard isViewLoaded, let category = category else { return }
      textField?.stringValue = category.name
    }
  }
  
  deinit {
    print("deinit CategoryItem")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer?.cornerRadius = 10.0
  }
}

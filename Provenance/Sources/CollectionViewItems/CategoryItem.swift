import Cocoa

final class CategoryItem: CollectionViewItem {
  @IBAction func copyCategoryName(_ sender: NSMenuItem) {
    NSPasteboard.general.setString(textField?.stringValue ?? .emptyString, forType: .string)
  }
  
  var category: CategoryViewModel? {
    didSet {
      guard isViewLoaded else { return }
      if let category = category {
        textField?.stringValue = category.name
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  private func configureView() {
    view.layer?.cornerRadius = 10.0
  }
}

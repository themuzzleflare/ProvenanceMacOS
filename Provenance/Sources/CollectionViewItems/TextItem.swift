import Cocoa

final class TextItem: CollectionViewItem {
  override func viewDidLoad() {
    super.viewDidLoad()
    textField?.maximumNumberOfLines = 3
  }

  deinit {
    print("\(#function) \(String(describing: type(of: self)))")
  }
}

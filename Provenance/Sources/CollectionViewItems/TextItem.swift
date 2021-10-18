import Cocoa

final class TextItem: CollectionViewItem {
  deinit {
    print("deinit TextItem")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    textField?.maximumNumberOfLines = 3
  }
}

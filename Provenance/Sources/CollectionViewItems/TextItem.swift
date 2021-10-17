import Cocoa

final class TextItem: CollectionViewItem {
  override func viewDidLoad() {
    super.viewDidLoad()
    textField?.maximumNumberOfLines = 3
  }
  
  override func updateSelectionHighlighting() {
    guard isViewLoaded else { return }
    super.updateSelectionHighlighting()
  }
}

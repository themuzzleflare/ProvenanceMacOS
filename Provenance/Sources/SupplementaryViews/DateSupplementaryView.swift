import Cocoa

final class DateSupplementaryView: NSVisualEffectView, NSCollectionViewElement {
  @IBOutlet weak var label: NSTextField! {
    didSet {
      material = .headerView
    }
  }
}

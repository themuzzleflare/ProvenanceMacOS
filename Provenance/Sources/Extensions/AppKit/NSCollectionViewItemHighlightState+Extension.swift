import AppKit

extension NSCollectionViewItem.HighlightState {
  var description: String {
    switch self {
    case .none:
      return "None"
    case .forSelection:
      return "For Selection"
    case .forDeselection:
      return "For Deselection"
    case .asDropTarget:
      return "As Drop Target"
    @unknown default:
      return "Unknown Default"
    }
  }
}

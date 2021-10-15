import AppKit

extension NSSearchField {
  convenience init(_ delegate: NSSearchFieldDelegate, type: ContentType) {
    self.init()
    self.delegate = delegate
    self.placeholderString = type.searchPlaceholder
  }
}

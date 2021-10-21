import AppKit

extension NSAttributedString {
  convenience init(text: String?, font: NSFont? = nil, colour: NSColor? = nil, alignment: NSParagraphStyle? = nil) {
    self.init(
      string: text ?? "",
      attributes: [
        .font: font ?? .circularStdBook(size: .labelFontSize),
        .foregroundColor: colour ?? .labelColor,
        .paragraphStyle: alignment ?? .leftAligned
      ]
    )
  }
}

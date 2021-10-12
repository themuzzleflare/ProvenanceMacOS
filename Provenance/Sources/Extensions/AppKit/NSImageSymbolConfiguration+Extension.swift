import AppKit

extension NSImage.SymbolConfiguration {
  static var small: NSImage.SymbolConfiguration {
    return NSImage.SymbolConfiguration(scale: .small)
  }
  
  static var large: NSImage.SymbolConfiguration {
    return NSImage.SymbolConfiguration(scale: .large)
  }
  
  static var noContent: NSImage.SymbolConfiguration {
    return NSImage.SymbolConfiguration(pointSize: 100, weight: .regular)
  }
}

import AppKit

extension NSImage {
  convenience init?(systemName: String) {
    self.init(systemSymbolName: systemName, accessibilityDescription: nil)
  }
  
  static var upLogoRounded: NSImage {
    return NSImage(named: "UpLogoRounded")!
  }
  
  static var dollarsignCircle: NSImage {
    return NSImage(systemName: "dollarsign.circle")!
  }
  
  static var dollarsignCircleFill: NSImage {
    return NSImage(systemName: "dollarsign.circle.fill")!
  }
  
  static var walletPass: NSImage {
    return NSImage(systemName: "wallet.pass")!
  }
  
  static var walletPassFill: NSImage {
    return NSImage(systemName: "wallet.pass.fill")!
  }
  
  static var tag: NSImage {
    return NSImage(systemName: "tag")!
  }
  
  static var tagFill: NSImage {
    return NSImage(systemName: "tag.fill")!
  }
  
  static var trayFull: NSImage {
    return NSImage(systemName: "tray.full")!
  }
  
  static var trayFullFill: NSImage {
    return NSImage(systemName: "tray.full.fill")!
  }
  
  static var infoCircle: NSImage {
    return NSImage(systemName: "info.circle")!
  }
  
  static var infoCircleFill: NSImage {
    return NSImage(systemName: "info.circle.fill")!
  }
  
  static var arrowUpArrowDown: NSImage {
    return NSImage(systemName: "arrow.up.arrow.down")!
  }
  
  static var arrowUpArrowDownCircle: NSImage {
    return NSImage(systemName: "arrow.up.arrow.down.circle")!
  }
  
  static var arrowUpArrowDownCircleFill: NSImage {
    return NSImage(systemName: "arrow.up.arrow.down.circle.fill")!
  }
  
  static var checkmarkCircle: NSImage {
    return NSImage(systemName: "checkmark.circle")!
  }
  
  static var checkmarkCircleFill: NSImage {
    return NSImage(systemName: "checkmark.circle.fill")!
  }
  
  static var clock: NSImage {
    return NSImage(systemName: "clock")!
  }
  
  static var clockFill: NSImage {
    return NSImage(systemName: "clock.fill")!
  }
  
  static var boltHorizontalCircle: NSImage {
    return NSImage(systemName: "bolt.horizontal.circle")!
  }
  
  static var boltHorizontalCircleFill: NSImage {
    return NSImage(systemName: "bolt.horizontal.circle.fill")!
  }
  
  static var calendarCircle: NSImage {
    return NSImage(systemName: "calendar.circle")!
  }
  
  static var calendarBadgeClock: NSImage {
    return NSImage(systemName: "calendar.badge.clock")!
  }
  
  static var chevronLeftSlashChevronRight: NSImage {
    return NSImage(systemName: "chevron.left.slash.chevron.right")!
  }
  
  static var docOnClipboard: NSImage {
    return NSImage(systemName: "doc.on.clipboard")!
  }
  
  static var envelope: NSImage {
    return NSImage(systemName: "envelope")!
  }
  
  static var envelopeFill: NSImage {
    return NSImage(systemName: "envelope.fill")!
  }
  
  static var exclamationmarkTriangleFill: NSImage {
    return NSImage(systemName: "exclamationmark.triangle.fill")!
  }
  
  static var gear: NSImage {
    return NSImage(systemName: "gear")!
  }
  
  static var gearshape: NSImage {
    return NSImage(systemName: "gearshape")!
  }
  
  static var linkCircle: NSImage {
    return NSImage(systemName: "link.circle")!
  }
  
  static var link: NSImage {
    return NSImage(systemName: "link")!
  }
  
  static var sliderHorizontal3: NSImage {
    return NSImage(systemName: "slider.horizontal.3")!
  }
  
  static var sliderVertical3: NSImage {
    return NSImage(systemName: "slider.vertical.3")!
  }
  
  static var textAlignright: NSImage {
    return NSImage(systemName: "text.alignright")!
  }
  
  static var trash: NSImage {
    return NSImage(systemName: "trash")!
  }
  
  static var xmarkDiamond: NSImage {
    return NSImage(systemName: "xmark.diamond")!
  }
  
  static var xmarkDiamondFill: NSImage {
    return NSImage(systemName: "xmark.diamond.fill")!
  }
  
  static var squareStack: NSImage {
    return NSImage(systemName: "square.stack")!
  }
  
  static var squareStackFill: NSImage {
    return NSImage(systemName: "square.stack.fill")!
  }
}

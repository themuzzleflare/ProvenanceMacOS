import Foundation
import CoreGraphics

extension Int {
    /// NSNumber.
  var nsNumber: NSNumber {
    return NSNumber(value: self)
  }
  
    /// UInt.
  var uInt: UInt {
    return UInt(self)
  }
  
    /// Double.
  var double: Double {
    return Double(self)
  }
  
    /// Float.
  var float: Float {
    return Float(self)
  }
  
    /// CGFloat.
  var cgFloat: CGFloat {
    return CGFloat(self)
  }
}

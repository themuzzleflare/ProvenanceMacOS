import Foundation
import CoreGraphics

extension Double {
  /// NSNumber.
  var nsNumber: NSNumber {
    return NSNumber(value: self)
  }
  
  /// Int.
  var integer: Int {
    return Int(self)
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

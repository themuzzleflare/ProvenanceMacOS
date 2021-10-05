import Foundation

extension Bool {
    /// Return 1 if true, or 0 if false.
  var integer: Int {
    return self ? 1 : 0
  }
  
    /// Return "true" if true, or "false" if false.
  var string: String {
    return self ? "true" : "false"
  }
}

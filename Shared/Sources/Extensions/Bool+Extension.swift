import AppKit

extension Bool {
  var controlState: NSControl.StateValue {
    return self ? .on : .off
  }
}

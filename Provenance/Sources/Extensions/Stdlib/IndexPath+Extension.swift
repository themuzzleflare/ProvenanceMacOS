import Foundation

extension Array where Element == IndexPath {
  var set: Set<IndexPath> {
    return Set(self)
  }
}

import Foundation

enum CategoryTypeEnum: Int, CaseIterable {
  case parent = 0
  case child = 1
}

extension CategoryTypeEnum {
  var description: String {
    switch self {
    case .parent:
      return "Parent"
    case .child:
      return "Child"
    }
  }
}

import AppKit

struct DetailItem: Identifiable {
  let id: String
  let value: String
}

// MARK: - Hashable

extension DetailItem: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: DetailItem, rhs: DetailItem) -> Bool {
    lhs.id == rhs.id && lhs.value == rhs.value
  }
}

extension DetailItem {
  var valueFont: NSFont {
    switch id {
    case "Raw Text", "Account ID":
      return .sfMonoRegular(size: 14)
    default:
      return .circularStdBook(size: 14)
    }
  }
}

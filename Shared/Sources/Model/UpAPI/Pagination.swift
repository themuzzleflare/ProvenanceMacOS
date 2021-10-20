import Foundation

struct Pagination: Codable {
  /// The link to the previous page in the results.
  /// If this value is `null` there is no previous page.
  var prev: String?

  /// The link to the next page in the results.
  /// If this value is `null` there is no next page.
  var next: String?
}

extension Pagination {
  var prevCursor: String? {
    guard let prev = prev,
          let url = URLComponents(string: prev),
          let cursor = url.queryItems?.first(where: { $0.name == Up.ParamKeys.pageBefore })?.value
    else { return nil }
    return cursor
  }

  var nextCursor: String? {
    guard let next = next,
          let url = URLComponents(string: next),
          let cursor = url.queryItems?.first(where: { $0.name == Up.ParamKeys.pageAfter })?.value
    else { return nil }
    return cursor
  }
}

import Foundation

struct Pagination: Codable {
    /// The link to the previous page in the results. If this value is `null` there is no previous page.
  var prev: String?
  
    /// The link to the next page in the results. If this value is `null` there is no next page.
  var next: String?
}

extension Pagination {
  var prevCursor: String? {
    guard let pagePrev = prev, let cursorUrl = URLComponents(string: pagePrev), let prevPageParameter = cursorUrl.queryItems?.first(where: { $0.name == UpFacade.ParamKeys.pageBefore })?.value else {
      return nil
    }
    return prevPageParameter
  }
  
  var nextCursor: String? {
    guard let pageNext = next, let cursorUrl = URLComponents(string: pageNext), let nextPageParameter = cursorUrl.queryItems?.first(where: { $0.name == UpFacade.ParamKeys.pageAfter })?.value else {
      return nil
    }
    return nextPageParameter
  }
}

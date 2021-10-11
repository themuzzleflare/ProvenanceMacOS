import Foundation

struct InfoPlist {
  static var cfBundleIdentifier: String {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? .emptyString
  }
  
  static var nsHumanReadableCopyright: String {
    return Bundle.main.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String ?? .emptyString
  }
}

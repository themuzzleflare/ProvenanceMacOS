import Foundation

class InfoPlist {
  static var cfBundleIdentifier: String {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? ""
  }
  
  static var nsHumanReadableCopyright: String {
    return Bundle.main.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String ?? ""
  }
}

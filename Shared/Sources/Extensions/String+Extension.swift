import Intents

extension String {
  static var emptyString: String {
    return ""
  }
  
  static var space: String {
    return " "
  }
  
  var integer: Int? {
    return Int(self)
  }
  
  var url: URL? {
    return URL(string: self)
  }
  
  var nsString: NSString {
    return NSString(string: self)
  }
  
  var nsDecimalNumber: NSDecimalNumber {
    return NSDecimalNumber(string: self)
  }
  
  var tagInputResourceIdentifier: TagInputResourceIdentifier {
    return TagInputResourceIdentifier(id: self)
  }
  
  var stringResolutionResult: INStringResolutionResult {
    return .success(with: self)
  }
  
  var addTagToTransactionTagsResolutionResult: AddTagToTransactionTagsResolutionResult {
    return .success(with: self)
  }
}

extension Array where Element == String {
  var tagInputResourceIdentifiers: [TagInputResourceIdentifier] {
    return self.map { (tag) in
      return tag.tagInputResourceIdentifier
    }
  }
  
  var stringResolutionResults: [INStringResolutionResult] {
    return self.map { (string) in
      return string.stringResolutionResult
    }
  }
  
  var addTagToTransactionTagsResolutionResults: [AddTagToTransactionTagsResolutionResult] {
    return self.map { (string) in
      return string.addTagToTransactionTagsResolutionResult
    }
  }
}

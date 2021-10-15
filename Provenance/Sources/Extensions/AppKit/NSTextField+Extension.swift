import AppKit

extension NSTextField {
  func clear() {
    self.stringValue = .emptyString
  }
  
  var tagResource: TagResource {
    return TagResource(id: self.stringValue)
  }
}

extension Array where Element: NSTextField {
  func clear() {
    self.forEach { (textField) in
      textField.clear()
    }
  }
  
  var textsJoined: String {
    return self.map { (textField) in
      return textField.stringValue
    }.joined()
  }
  
  var tagResources: [TagResource] {
    return self.map { (textField) in
      return textField.tagResource
    }.filter { (tag) in
      return !tag.id.isEmpty
    }
  }
}

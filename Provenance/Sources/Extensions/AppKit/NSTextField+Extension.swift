import AppKit

extension NSTextField {
  var tagResource: TagResource {
    return TagResource(id: self.stringValue)
  }

  func clear() {
    self.stringValue = .emptyString
  }
}

extension Array where Element: NSTextField {
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

  func clear() {
    self.forEach { (textField) in
      textField.clear()
    }
  }
}

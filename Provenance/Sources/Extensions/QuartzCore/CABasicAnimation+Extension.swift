import QuartzCore

extension CABasicAnimation {
  convenience init(keyPath path: String?, fromValue: Any?, toValue: Any?, duration: CFTimeInterval) {
    self.init(keyPath: path)
    self.fromValue = fromValue
    self.toValue = toValue
    self.duration = duration
  }
}

import AppKit

extension NSDirectionalEdgeInsets {
  static var transactionDetailSection: NSDirectionalEdgeInsets {
    return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30.0, trailing: 0)
  }

  init(all: CGFloat) {
    self.init(top: all, leading: all, bottom: all, trailing: all)
  }

  init(bottom: CGFloat) {
    self.init(top: 0, leading: 0, bottom: bottom, trailing: 0)
  }
}

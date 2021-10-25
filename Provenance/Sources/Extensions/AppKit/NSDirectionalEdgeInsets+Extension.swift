import AppKit

extension NSDirectionalEdgeInsets {
  init(all: CGFloat) {
    self.init(top: all, leading: all, bottom: all, trailing: all)
  }

  init(bottom: CGFloat) {
    self.init(top: 0, leading: 0, bottom: bottom, trailing: 0)
  }
}

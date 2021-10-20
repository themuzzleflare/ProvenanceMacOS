import AppKit

extension NSSegmentedControl {
  static func categories(filter: TransactionCategory, menu: NSMenu) -> NSSegmentedControl {
    let segmentedControl = NSSegmentedControl(images: [filter == .all ? .trayFull : .trayFullFill],
                                              trackingMode: .selectOne,
                                              target: nil,
                                              action: nil)
    segmentedControl.setMenu(menu, forSegment: 0)
    segmentedControl.setShowsMenuIndicator(true, forSegment: 0)
    segmentedControl.setSelected(filter == .all ? false : true, forSegment: 0)
    return segmentedControl
  }
}

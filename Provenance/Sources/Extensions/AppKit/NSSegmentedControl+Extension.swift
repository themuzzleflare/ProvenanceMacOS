import AppKit

extension NSSegmentedControl {
  static func categories(menu: NSMenu) -> NSSegmentedControl {
    let segmentedControl = NSSegmentedControl(images: [ProvenanceApp.userDefaults.appSelectedCategory == .all ? .trayFull : .trayFullFill],
                                              trackingMode: .selectOne,
                                              target: nil,
                                              action: nil)
    segmentedControl.setMenu(menu, forSegment: 0)
    segmentedControl.setShowsMenuIndicator(true, forSegment: 0)
    return segmentedControl
  }
}

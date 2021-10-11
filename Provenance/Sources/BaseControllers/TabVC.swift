import Cocoa

final class TabVC: NSTabViewController {  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
  
  private func configure() {
    tabStyle = .segmentedControlOnTop
    TabBarItem.allCases.tabViewItems.forEach { (item) in
      addTabViewItem(item)
    }
  }
}

import Cocoa

final class TabVC: NSTabViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    tabStyle = .segmentedControlOnTop
    tabViewItems = TabBarItem.allCases.tabViewItems
    tabViewItems.first?.image = .dollarsignCircleFill
  }

  override func viewWillAppear() {
    super.viewWillAppear()
    guard let appDelegate = NSApp.delegate as? AppDelegate else { return }
    appDelegate.tabMenuItems.forEach { $0.target = self }
    appDelegate.transactionsMenuItem.action = #selector(transactions)
    appDelegate.accountsMenuItem.action = #selector(accounts)
    appDelegate.tagsMenuItem.action = #selector(tags)
    appDelegate.categoriesMenuItem.action = #selector(categories)
  }

  override func viewWillDisappear() {
    super.viewWillDisappear()
    guard let appDelegate = NSApp.delegate as? AppDelegate else { return }
    appDelegate.tabMenuItems.forEach { $0.action = nil }
  }

  override func tabView(_ tabView: NSTabView, willSelect tabViewItem: NSTabViewItem?) {
    guard let previousTabViewItem = tabView.selectedTabViewItem,
          let tabViewItem = tabViewItem,
          let previousIdentifier = previousTabViewItem.identifier as? String,
          let identifier = tabViewItem.identifier as? String,
          let previousTabBarItem = TabBarItem(rawValue: previousIdentifier),
          let tabBarItem = TabBarItem(rawValue: identifier)
    else { return }
    previousTabBarItem.menuItem?.state = .off
    tabBarItem.menuItem?.state = .on
    previousTabViewItem.image = previousTabBarItem.image
    tabViewItem.image = tabBarItem.selectedImage
    super.tabView(tabView, willSelect: tabViewItem)
  }

  @objc
  private func transactions() {
    tabView.selectTabViewItem(withIdentifier: TabBarItem.transactions.rawValue)
  }

  @objc
  private func accounts() {
    tabView.selectTabViewItem(withIdentifier: TabBarItem.accounts.rawValue)
  }

  @objc
  private func tags() {
    tabView.selectTabViewItem(withIdentifier: TabBarItem.tags.rawValue)
  }

  @objc
  private func categories() {
    tabView.selectTabViewItem(withIdentifier: TabBarItem.categories.rawValue)
  }
}

import Cocoa

final class TabVC: NSTabViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    tabStyle = .segmentedControlOnTop
    tabViewItems = TabBarItem.allCases.tabViewItems
  }

  override func viewWillAppear() {
    super.viewWillAppear()
    guard let applicationDelegate = NSApp.delegate as? AppDelegate else { return }
    applicationDelegate.transactionsMenuItem.action = #selector(transactions)
    applicationDelegate.accountsMenuItem.action = #selector(accounts)
    applicationDelegate.tagsMenuItem.action = #selector(tags)
    applicationDelegate.categoriesMenuItem.action = #selector(categories)
  }

  override func viewWillDisappear() {
    super.viewWillDisappear()
    guard let applicationDelegate = NSApp.delegate as? AppDelegate else { return }
    applicationDelegate.transactionsMenuItem.action = nil
    applicationDelegate.accountsMenuItem.action = nil
    applicationDelegate.tagsMenuItem.action = nil
    applicationDelegate.categoriesMenuItem.action = nil
  }

  override func tabView(_ tabView: NSTabView, willSelect tabViewItem: NSTabViewItem?) {
    guard let previousTabViewItem = tabView.selectedTabViewItem,
          let tabViewItem = tabViewItem,
          let previousIdentifier = previousTabViewItem.identifier as? String,
          let identifier = tabViewItem.identifier as? String,
          let previousTabBarItem = TabBarItem(rawValue: previousIdentifier),
          let tabBarItem = TabBarItem(rawValue: identifier)
    else {
      return
    }
    previousTabBarItem.menuItem?.state = .off
    tabBarItem.menuItem?.state = .on
    selectedTabViewItemIndex = tabView.indexOfTabViewItem(tabViewItem)
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

import Cocoa

final class TabVC: NSTabViewController {
  @objc private func transactions() {
    tabView.selectTabViewItem(withIdentifier: TabBarItem.transactions.identifier)
  }
  
  @objc private func accounts() {
    tabView.selectTabViewItem(withIdentifier: TabBarItem.accounts.identifier)
  }
  
  @objc private func tags() {
    tabView.selectTabViewItem(withIdentifier: TabBarItem.tags.identifier)
  }
  
  @objc private func categories() {
    tabView.selectTabViewItem(withIdentifier: TabBarItem.categories.identifier)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    guard let applicationDelegate = NSApp.delegate as? AppDelegate else { return }
    applicationDelegate.transactionsMenuItem.action = #selector(transactions)
    applicationDelegate.accountsMenuItem.action = #selector(accounts)
    applicationDelegate.tagsMenuItem.action = #selector(tags)
    applicationDelegate.categoriesMenuItem.action = #selector(categories)
  }
  
  override func viewDidDisappear() {
    super.viewDidDisappear()
    guard let applicationDelegate = NSApp.delegate as? AppDelegate else { return }
    applicationDelegate.transactionsMenuItem.action = nil
    applicationDelegate.accountsMenuItem.action = nil
    applicationDelegate.tagsMenuItem.action = nil
    applicationDelegate.categoriesMenuItem.action = nil
  }
  
  override func tabView(_ tabView: NSTabView, willSelect tabViewItem: NSTabViewItem?) {
    guard let applicationDelegate = NSApp.delegate as? AppDelegate, let previousTabViewItem = tabView.selectedTabViewItem, let tabViewItem = tabViewItem, let previousIdentifier = previousTabViewItem.identifier as? String, let identifier = tabViewItem.identifier as? String else { return }
    switch previousIdentifier {
    case TabBarItem.transactions.identifier:
      applicationDelegate.transactionsMenuItem.state = .off
      previousTabViewItem.image = TabBarItem.transactions.image
    case TabBarItem.accounts.identifier:
      applicationDelegate.accountsMenuItem.state = .off
      previousTabViewItem.image = TabBarItem.accounts.image
    case TabBarItem.tags.identifier:
      applicationDelegate.tagsMenuItem.state = .off
      previousTabViewItem.image = TabBarItem.tags.image
    case TabBarItem.categories.identifier:
      applicationDelegate.categoriesMenuItem.state = .off
      previousTabViewItem.image = TabBarItem.categories.image
    default:
      break
    }
    switch identifier {
    case TabBarItem.transactions.identifier:
      applicationDelegate.transactionsMenuItem.state = .on
      tabViewItem.image = TabBarItem.transactions.selectedImage
    case TabBarItem.accounts.identifier:
      applicationDelegate.accountsMenuItem.state = .on
      tabViewItem.image = TabBarItem.accounts.selectedImage
    case TabBarItem.tags.identifier:
      applicationDelegate.tagsMenuItem.state = .on
      tabViewItem.image = TabBarItem.tags.selectedImage
    case TabBarItem.categories.identifier:
      applicationDelegate.categoriesMenuItem.state = .on
      tabViewItem.image = TabBarItem.categories.selectedImage
    default:
      break
    }
    
    selectedTabViewItemIndex = tabView.indexOfTabViewItem(tabViewItem)
  }
  
  private func configure() {
    tabStyle = .segmentedControlOnTop
    TabBarItem.allCases.tabViewItems.forEach { (item) in
      addTabViewItem(item)
    }
  }
}

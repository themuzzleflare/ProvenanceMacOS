import Cocoa

final class PreferencesVC: NSViewController {
  private var apiKeyObserver: NSKeyValueObservation?

  private var dateStyleObserver: NSKeyValueObservation?

  private var accountFilterObserver: NSKeyValueObservation?

  private var categoryFilterObserver: NSKeyValueObservation?

  private lazy var apiKey: String = App.userDefaults.apiKey {
    didSet {
      if App.userDefaults.apiKey != apiKey {
        App.userDefaults.apiKey = apiKey
      }
      if apiKeyTextField.stringValue != apiKey {
        apiKeyTextField.stringValue = apiKey
      }
    }
  }

  private lazy var dateStyle: AppDateStyle = App.userDefaults.appDateStyle {
    didSet {
      if App.userDefaults.dateStyle != dateStyle.rawValue {
        App.userDefaults.dateStyle = dateStyle.rawValue
      }
      if dateStyleButton.indexOfSelectedItem != dateStyle.rawValue {
        dateStyleButton.selectItem(at: dateStyle.rawValue)
      }
    }
  }

  private lazy var accountFilter: AccountTypeOptionEnum = App.userDefaults.appAccountFilter {
    didSet {
      if App.userDefaults.accountFilter != accountFilter.rawValue {
        App.userDefaults.accountFilter = accountFilter.rawValue
      }
      if accountFilterButton.indexOfSelectedItem != accountFilter.rawValue {
        accountFilterButton.selectItem(at: accountFilter.rawValue)
      }
    }
  }

  private lazy var categoryFilter: CategoryTypeEnum = App.userDefaults.appCategoryFilter {
    didSet {
      if App.userDefaults.categoryFilter != categoryFilter.rawValue {
        App.userDefaults.categoryFilter = categoryFilter.rawValue
      }
      if categoryFilterButton.indexOfSelectedItem != categoryFilter.rawValue {
        categoryFilterButton.selectItem(at: categoryFilter.rawValue)
      }
    }
  }

  @IBOutlet weak var apiKeyTextField: NSTextField! {
    didSet {
      apiKeyTextField.stringValue = apiKey
    }
  }

  @IBOutlet weak var dateStyleButton: NSPopUpButton! {
    didSet {
      dateStyleButton.selectItem(at: dateStyle.rawValue)
    }
  }

  @IBOutlet weak var accountFilterButton: NSPopUpButton! {
    didSet {
      accountFilterButton.selectItem(at: accountFilter.rawValue)
    }
  }

  @IBOutlet weak var categoryFilterButton: NSPopUpButton! {
    didSet {
      categoryFilterButton.selectItem(at: categoryFilter.rawValue)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureObservers()
  }

  @IBAction func apiKeyAction(_ sender: NSTextField) {
    apiKey = sender.stringValue
  }

  @IBAction func dateStyleAction(_ sender: NSPopUpButton) {
    if let value = AppDateStyle(rawValue: sender.indexOfSelectedItem) {
      dateStyle = value
    }
  }

  @IBAction func accountFilterAction(_ sender: NSPopUpButton) {
    if let value = AccountTypeOptionEnum(rawValue: sender.indexOfSelectedItem) {
      accountFilter = value
    }
  }

  @IBAction func categoryFilterAction(_ sender: NSPopUpButton) {
    if let value = CategoryTypeEnum(rawValue: sender.indexOfSelectedItem) {
      categoryFilter = value
    }
  }

  private func configureObservers() {
    apiKeyObserver = App.userDefaults.observe(\.apiKey, options: .new) { [weak self] (_, change) in
      guard let value = change.newValue else { return }
      self?.apiKey = value
    }
    dateStyleObserver = App.userDefaults.observe(\.dateStyle, options: .new) { [weak self] (_, change) in
      guard let value = change.newValue, let dateStyleEnum = AppDateStyle(rawValue: value) else { return }
      self?.dateStyle = dateStyleEnum
    }
    accountFilterObserver = App.userDefaults.observe(\.accountFilter, options: .new) { [weak self] (_, change) in
      guard let value = change.newValue, let accountTypeEnum = AccountTypeOptionEnum(rawValue: value) else { return }
      self?.accountFilter = accountTypeEnum
    }
    categoryFilterObserver = App.userDefaults.observe(\.categoryFilter, options: .new) { [weak self] (_, change) in
      guard let value = change.newValue, let categoryTypeEnum = CategoryTypeEnum(rawValue: value) else { return }
      self?.categoryFilter = categoryTypeEnum
    }
  }

  private func removeObservers() {
    apiKeyObserver?.invalidate()
    apiKeyObserver = nil
    dateStyleObserver?.invalidate()
    dateStyleObserver = nil
    accountFilterObserver?.invalidate()
    accountFilterObserver = nil
    categoryFilterObserver?.invalidate()
    categoryFilterObserver = nil
  }

  deinit {
    removeObservers()
    print("deinit")
  }
}

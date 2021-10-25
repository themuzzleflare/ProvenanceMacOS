import Cocoa

final class PreferencesVC: NSViewController {
  private var apiKeyObserver: NSKeyValueObservation?

  private var dateStyleObserver: NSKeyValueObservation?

  private var accountFilterObserver: NSKeyValueObservation?

  private var categoryFilterObserver: NSKeyValueObservation?

  private lazy var apiKey: String = UserDefaults.provenance.apiKey {
    didSet {
      if UserDefaults.provenance.apiKey != apiKey {
        UserDefaults.provenance.apiKey = apiKey
      }
      if apiKeyTextField.stringValue != apiKey {
        apiKeyTextField.stringValue = apiKey
      }
    }
  }

  private lazy var dateStyle: AppDateStyle = UserDefaults.provenance.appDateStyle {
    didSet {
      if UserDefaults.provenance.dateStyle != dateStyle.rawValue {
        UserDefaults.provenance.dateStyle = dateStyle.rawValue
      }
      if dateStyleButton.indexOfSelectedItem != dateStyle.rawValue {
        dateStyleButton.selectItem(at: dateStyle.rawValue)
      }
    }
  }

  private lazy var accountFilter: AccountTypeOptionEnum = UserDefaults.provenance.appAccountFilter {
    didSet {
      if UserDefaults.provenance.accountFilter != accountFilter.rawValue {
        UserDefaults.provenance.accountFilter = accountFilter.rawValue
      }
      if accountFilterButton.indexOfSelectedItem != accountFilter.rawValue {
        accountFilterButton.selectItem(at: accountFilter.rawValue)
      }
    }
  }

  private lazy var categoryFilter: CategoryTypeEnum = UserDefaults.provenance.appCategoryFilter {
    didSet {
      if UserDefaults.provenance.categoryFilter != categoryFilter.rawValue {
        UserDefaults.provenance.categoryFilter = categoryFilter.rawValue
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
    apiKeyObserver = UserDefaults.provenance.observe(\.apiKey, options: .new) { [weak self] (_, change) in
      guard let value = change.newValue else { return }
      self?.apiKey = value
    }
    dateStyleObserver = UserDefaults.provenance.observe(\.dateStyle, options: .new) { [weak self] (_, change) in
      guard let value = change.newValue, let dateStyleEnum = AppDateStyle(rawValue: value) else { return }
      self?.dateStyle = dateStyleEnum
    }
    accountFilterObserver = UserDefaults.provenance.observe(\.accountFilter, options: .new) { [weak self] (_, change) in
      guard let value = change.newValue, let accountTypeEnum = AccountTypeOptionEnum(rawValue: value) else { return }
      self?.accountFilter = accountTypeEnum
    }
    categoryFilterObserver = UserDefaults.provenance.observe(\.categoryFilter, options: .new) { [weak self] (_, change) in
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
    print("\(#function) \(String(describing: type(of: self)))")
  }
}

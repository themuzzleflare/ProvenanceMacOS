import Cocoa

final class PreferencesVC: NSViewController {
  private var apiKeyObserver: NSKeyValueObservation?

  private var dateStyleObserver: NSKeyValueObservation?

  private var accountFilterObserver: NSKeyValueObservation?

  private var categoryFilterObserver: NSKeyValueObservation?

  @IBOutlet weak var apiKeyTextField: NSTextField! {
    didSet {
      apiKeyTextField.stringValue = ProvenanceApp.userDefaults.apiKey
    }
  }

  @IBOutlet weak var dateStylePopupButton: NSPopUpButton! {
    didSet {
      dateStylePopupButton.selectItem(at: ProvenanceApp.userDefaults.dateStyle)
    }
  }

  @IBOutlet weak var accountFilter: NSPopUpButton! {
    didSet {
      accountFilter.selectItem(at: ProvenanceApp.userDefaults.accountFilter)
    }
  }

  @IBOutlet weak var categoryFilter: NSPopUpButton! {
    didSet {
      categoryFilter.selectItem(at: ProvenanceApp.userDefaults.categoryFilter)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureObservers()
  }

  @IBAction func apiKeyAction(_ sender: NSTextField) {
    ProvenanceApp.userDefaults.apiKey = sender.stringValue
  }

  @IBAction func dateStyleAction(_ sender: NSPopUpButton) {
    ProvenanceApp.userDefaults.dateStyle = sender.indexOfSelectedItem
  }

  @IBAction func accountFilterAction(_ sender: NSPopUpButton) {
    ProvenanceApp.userDefaults.accountFilter = sender.indexOfSelectedItem
  }

  @IBAction func categoryFilterAction(_ sender: NSPopUpButton) {
    ProvenanceApp.userDefaults.categoryFilter = sender.indexOfSelectedItem
  }

  private func configureObservers() {
    apiKeyObserver = ProvenanceApp.userDefaults.observe(\.apiKey, options: .new) { [weak self] (_, change) in
      guard let weakSelf = self, let value = change.newValue else { return }
      weakSelf.apiKeyTextField.stringValue = value
    }
    dateStyleObserver = ProvenanceApp.userDefaults.observe(\.dateStyle, options: .new) { [weak self] (_, change) in
      guard let weakSelf = self, let value = change.newValue else { return }
      weakSelf.dateStylePopupButton.selectItem(at: value)
    }
    accountFilterObserver = ProvenanceApp.userDefaults.observe(\.accountFilter, options: .new) { [weak self] (_, change) in
      guard let weakSelf = self, let value = change.newValue else { return }
      weakSelf.accountFilter.selectItem(at: value)
    }
    categoryFilterObserver = ProvenanceApp.userDefaults.observe(\.categoryFilter, options: .new) { [weak self] (_, change) in
      guard let weakSelf = self, let value = change.newValue else { return }
      weakSelf.categoryFilter.selectItem(at: value)
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

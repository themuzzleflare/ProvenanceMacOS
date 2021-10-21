import WidgetKit

extension UserDefaults {
  /// A `UserDefaults` instance for the application group.
  /// Observations should be made on a **stored variable** of this value.
  /// Key-value observations on computed variables do not work.
  static var provenance: UserDefaults {
    return UserDefaults(suiteName: "JDL5FY6SCC.group.cloud.tavitian.provenance") ?? .standard
  }

  /// The string of the "apiKey" key.
  @objc dynamic var apiKey: String {
    get {
      return string(forKey: Keys.apiKey) ?? ""
    }
    set {
      setValue(newValue, forKey: Keys.apiKey)
      WidgetCenter.shared.reloadAllTimelines()
    }
  }

  /// The integer of the "dateStyle" key.
  @objc dynamic var dateStyle: Int {
    get {
      return integer(forKey: Keys.dateStyle)
    }
    set {
      setValue(newValue, forKey: Keys.dateStyle)
      WidgetCenter.shared.reloadTimelines(ofKind: Widgets.latestTransaction.kind)
    }
  }

  /// The integer of the "accountFilter" key.
  @objc dynamic var accountFilter: Int {
    get {
      return integer(forKey: Keys.accountFilter)
    }
    set {
      setValue(newValue, forKey: Keys.accountFilter)
    }
  }

  /// The integer of the "categoryFilter" key.
  @objc dynamic var categoryFilter: Int {
    get {
      return integer(forKey: Keys.categoryFilter)
    }
    set {
      setValue(newValue, forKey: Keys.categoryFilter)
    }
  }

  /// The boolean of the "settledOnly" key.
  @objc dynamic var settledOnly: Bool {
    get {
      return bool(forKey: Keys.settledOnly)
    }
    set {
      setValue(newValue, forKey: Keys.settledOnly)
    }
  }

  /// The integer of the "transactionGrouping" key.
  @objc dynamic var transactionGrouping: Int {
    get {
      return integer(forKey: Keys.transactionGrouping)
    }
    set {
      setValue(newValue, forKey: Keys.transactionGrouping)
    }
  }

  @objc dynamic var paginationCursor: String {
    get {
      return string(forKey: Keys.paginationCursor) ?? ""
    }
    set {
      setValue(newValue, forKey: Keys.paginationCursor)
    }
  }

  /// The last selected account for the account balance widget.
  var selectedAccount: String? {
    get {
      return string(forKey: Keys.selectedAccount)
    }
    set {
      setValue(newValue, forKey: Keys.selectedAccount)
    }
  }

  var selectedCategory: String {
    get {
      return string(forKey: Keys.selectedCategory) ?? TransactionCategory.all.rawValue
    }
    set {
      setValue(newValue, forKey: Keys.selectedCategory)
    }
  }

  var appSelectedCategory: TransactionCategory {
    get {
      return TransactionCategory(rawValue: selectedCategory) ?? .all
    }
    set {
      selectedCategory = newValue.rawValue
    }
  }

  /// The configured `AppDateStyle` enumeration based on the integer of the "dateStyle" key.
  var appDateStyle: AppDateStyle {
    get {
      return AppDateStyle(rawValue: dateStyle) ?? .absolute
    }
    set {
      dateStyle = newValue.rawValue
    }
  }

  /// The configured `AccountTypeOptionEnum` enumeration based on the integer of the "accountFilter" key.
  var appAccountFilter: AccountTypeOptionEnum {
    get {
      return AccountTypeOptionEnum(rawValue: accountFilter) ?? .transactional
    }
    set {
      accountFilter = newValue.rawValue
    }
  }

  /// The configured `CategoryTypeEnum` enumeration based on the integer of the "categoryFilter" key.
  var appCategoryFilter: CategoryTypeEnum {
    get {
      return CategoryTypeEnum(rawValue: categoryFilter) ?? .parent
    }
    set {
      categoryFilter = newValue.rawValue
    }
  }

  /// The configured `TransactionGroupingEnum` enumeration based on the integer of the "transactionGrouping" key.
  var appTransactionGrouping: TransactionGroupingEnum {
    get {
      return TransactionGroupingEnum(rawValue: transactionGrouping) ?? .all
    }
    set {
      transactionGrouping = newValue.rawValue
    }
  }

  /// The short version string of the application.
  var appVersion: String {
    return string(forKey: Keys.appVersion) ?? "Unknown"
  }

  /// The build number of the application.
  var appBuild: String {
    return string(forKey: Keys.appBuild) ?? "Unknown"
  }
}

extension UserDefaults {
  private enum Keys {
    static let apiKey = "apiKey"
    static let dateStyle = "dateStyle"
    static let accountFilter = "accountFilter"
    static let categoryFilter = "categoryFilter"
    static let settledOnly = "settledOnly"
    static let transactionGrouping = "transactionGrouping"
    static let selectedAccount = "selectedAccount"
    static let selectedCategory = "selectedCategory"
    static let paginationCursor = "paginationCursor"
    static let appVersion = "appVersion"
    static let appBuild = "appBuild"
  }
}

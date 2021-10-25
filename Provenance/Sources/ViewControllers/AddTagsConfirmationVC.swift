import Cocoa

final class AddTagsConfirmationVC: NSViewController {
  private var previousViewController: NSViewController

  private var transaction: TransactionResource

  private var tags: [TagResource]

  private lazy var toolbar = NSToolbar(self, identifier: .confirmation)

  private var dateStyleObserver: NSKeyValueObservation?

  @IBOutlet weak var collectionView: NSCollectionView! {
    didSet {
      collectionView.register(.tagItem, forItemWithIdentifier: .tagItem)
      collectionView.register(.transactionItem, forItemWithIdentifier: .transactionItem)
      collectionView.register(.textItem, forItemWithIdentifier: .textItem)
      collectionView.register(.textSupplementaryView,
                              forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader,
                              withIdentifier: .textSupplementaryView)
      collectionView.collectionViewLayout = .confirmation
    }
  }

  init(_ previousViewController: NSViewController, transaction: TransactionResource, tags: [TagResource]) {
    self.previousViewController = previousViewController
    self.transaction = transaction
    self.tags = tags
    super.init(nibName: "AddTagsConfirmation", bundle: nil)
  }

  convenience init(_ previousViewController: NSViewController, transaction: TransactionResource, tag: TagResource) {
    self.init(previousViewController, transaction: transaction, tags: .singleTag(with: tag))
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureObserver()
  }

  override func viewWillAppear() {
    super.viewWillAppear()
    configureWindow()
  }

  private func configureWindow() {
    AppDelegate.windowController?.window?.toolbar = toolbar
    AppDelegate.windowController?.window?.title = "Confirmation"
  }

  private func configureObserver() {
    dateStyleObserver = UserDefaults.provenance.observe(\.dateStyle, options: .new) { [weak self] (_, _) in
      self?.collectionView.reloadData()
    }
  }

  private func removeObserver() {
    dateStyleObserver?.invalidate()
    dateStyleObserver = nil
  }

  @objc
  private func goBack() {
    view.window?.contentViewController = .navigation(self, to: previousViewController)
  }

  @objc
  private func confirm() {
    toolbar.removeItem(at: 1)
    toolbar.insertItem(withItemIdentifier: .loading, at: 1)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
      Up.modifyTags(adding: tags, to: transaction) { (error) in
        DispatchQueue.main.async {
          if let error = error {
            let alert = NSAlert.tagsAddedFailure(error: error)
            alert.runModal()
          } else {
            let alert = NSAlert.tagsAddedSuccess(tags: tags, transaction: transaction)
            alert.runModal()
          }
          goBack()
        }
      }
    }
  }

  deinit {
    removeObserver()
    print("\(#function) \(String(describing: type(of: self)))")
  }
}

// MARK: - NSToolbarDelegate

extension AddTagsConfirmationVC: NSToolbarDelegate {
  func toolbar(_ toolbar: NSToolbar,
               itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
               willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
    switch itemIdentifier {
    case .backButton:
      return .backButton(self, title: "", action: #selector(goBack))
    case .confirm:
      return .confirm(self, action: #selector(confirm))
    case .loading:
      return .loading
    default:
      return nil
    }
  }

  func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return [.backButton, .confirm]
  }

  func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    return [.backButton, .confirm, .loading]
  }
}

// MARK: - NSCollectionViewDataSource

extension AddTagsConfirmationVC: NSCollectionViewDataSource {
  func numberOfSections(in collectionView: NSCollectionView) -> Int {
    return 3
  }

  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0:
      return tags.count
    case 1:
      return 1
    case 2:
      return 1
    default:
      fatalError()
    }
  }

  func collectionView(_ collectionView: NSCollectionView,
                      viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind,
                      at indexPath: IndexPath) -> NSView {
    guard let view = collectionView.makeSupplementaryView(ofKind: kind, withIdentifier: .textSupplementaryView, for: indexPath) as? TextSupplementaryView else { fatalError() }
    switch indexPath.section {
    case 0:
      view.label.stringValue = "Adding \(tags.count == 1 ? "Tag" : "Tags")".uppercased()
      return view
    case 1:
      view.label.stringValue = "To Transaction".uppercased()
      return view
    case 2:
      view.label.stringValue = "Summary".uppercased()
      return view
    default:
      fatalError()
    }
  }

  func collectionView(_ collectionView: NSCollectionView,
                      itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let tag = tags[indexPath.item]
    switch indexPath.section {
    case 0:
      guard let item = collectionView.makeItem(withIdentifier: .tagItem, for: indexPath) as? TagItem else { fatalError() }
      item.tag = tag.tagViewModel
      return item
    case 1:
      guard let item = collectionView.makeItem(withIdentifier: .transactionItem, for: indexPath) as? TransactionItem else { fatalError() }
      item.transaction = transaction.transactionViewModel
      return item
    case 2:
      guard let item = collectionView.makeItem(withIdentifier: .textItem, for: indexPath) as? TextItem else { fatalError() }
      item.textField?.stringValue = "You are adding \(tags.joinedWithComma) to \(transaction.attributes.description), which was \(UserDefaults.provenance.appDateStyle == .absolute ? "created on" : "created") \(transaction.attributes.creationDate)."
      return item
    default:
      fatalError()
    }
  }
}

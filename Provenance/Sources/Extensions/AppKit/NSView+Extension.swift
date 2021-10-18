import AppKit
import SnapKit

extension NSView {
  static var plainView: NSView {
    return NSView()
  }
  
  static func loadingView(frame: CGRect, contentType: ContentType) -> NSView {
    let view = NSView(frame: frame)
    let loadingIndicator = NSProgressIndicator(style: .spinning)
    view.addSubview(loadingIndicator)
    loadingIndicator.startAnimation(self)
    loadingIndicator.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
    return view
  }
  
  static func noContentView(frame: CGRect, type: ContentType) -> NSView {
    let view = NSView(frame: frame)
    let icon = NSImageView(image: .xmarkDiamond.withSymbolConfiguration(.noContent)!)
    icon.contentTintColor = .placeholderTextColor
    let label = NSTextField(wrappingLabelWithString: type.noContentDescription)
    label.isSelectable = false
    label.alignment = .center
    label.textColor = .placeholderTextColor
    label.font = .circularStdMedium(size: 23)
    label.maximumNumberOfLines = 2
    let verticalStack = NSStackView(views: [icon, label])
    view.addSubview(verticalStack)
    verticalStack.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(16)
      make.right.equalToSuperview().inset(16)
      make.center.equalToSuperview()
    }
    verticalStack.orientation = .vertical
    verticalStack.alignment = .centerX
    verticalStack.spacing = 30
    return view
  }
  
  static func errorView(frame: CGRect, text: String) -> NSView {
    let view = NSView(frame: frame)
    let label = NSTextField(wrappingLabelWithString: text)
    view.addSubview(label)
    label.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(16)
      make.right.equalToSuperview().inset(16)
      make.center.equalToSuperview()
    }
    label.isSelectable = false
    label.alignment = .center
    label.textColor = .placeholderTextColor
    label.font = .circularStdBook(size: 15)
    label.maximumNumberOfLines = 5
    return view
  }
  
  static func accountTransactionsHeaderView(frame: CGRect, account: AccountResource) -> NSView {
    let view = NSView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 117))
    let balanceLabel = NSTextField(wrappingLabelWithString: account.attributes.balance.valueShort)
    let displayNameLabel = NSTextField(wrappingLabelWithString: account.attributes.displayName)
    let verticalStack = NSStackView(views: [balanceLabel, displayNameLabel])
    view.addSubview(verticalStack)
    verticalStack.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(16)
      make.right.equalToSuperview().inset(16)
      make.center.equalToSuperview()
    }
    verticalStack.orientation = .vertical
    verticalStack.alignment = .centerX
    balanceLabel.textColor = .accentColor
    balanceLabel.font = .circularStdBold(size: 32)
    balanceLabel.alignment = .center
    balanceLabel.maximumNumberOfLines = 0
    displayNameLabel.textColor = .secondaryLabelColor
    displayNameLabel.font = .circularStdBook(size: 14)
    displayNameLabel.alignment = .center
    displayNameLabel.maximumNumberOfLines = 0
    return view
  }
}

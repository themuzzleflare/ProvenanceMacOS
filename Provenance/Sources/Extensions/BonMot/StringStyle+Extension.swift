import BonMot

typealias StringStyle = BonMot.StringStyle

extension StringStyle {
  static var provenance: StringStyle {
    return StringStyle(
      .font(.circularStdBook(size: .labelFontSize)),
      .color(.labelColor),
      .alignment(.left)
    )
  }
  
  static var transactionDescription: StringStyle {
    return StringStyle(
      .font(.circularStdBold(size: .labelFontSize)),
      .color(.labelColor),
      .alignment(.left)
    )
  }
  
  static var transactionCreationDate: StringStyle {
    return StringStyle(
      .font(.circularStdBook(size: .smallSystemFontSize)),
      .color(.secondaryLabelColor),
      .alignment(.left)
    )
  }
  
  static var transactionAmount: StringStyle {
    return StringStyle(
      .font(.circularStdBook(size: .labelFontSize)),
      .color(.labelColor),
      .alignment(.right)
    )
  }
  
  static var accountBalance: StringStyle {
    return StringStyle(
      .font(.circularStdBold(size: 32)),
      .color(.accentColor),
      .alignment(.center)
    )
  }
  
  static var accountDisplayName: StringStyle {
    return StringStyle(
      .font(.circularStdBook(size: .labelFontSize)),
      .color(.labelColor),
      .alignment(.center)
    )
  }
  
  static var categoryName: StringStyle {
    return StringStyle(
      .font(.circularStdBook(size: .labelFontSize)),
      .color(.labelColor),
      .alignment(.center)
    )
  }
  
  static var aboutName: StringStyle {
    return StringStyle(
      .font(.circularStdBold(size: 32)),
      .color(.labelColor),
      .alignment(.center)
    )
  }
  
  static var aboutDescription: StringStyle {
    return StringStyle(
      .font(.circularStdBook(size: .labelFontSize)),
      .color(.secondaryLabelColor),
      .alignment(.left)
    )
  }
  
  static var leftText: StringStyle {
    return StringStyle(
      .font(.circularStdMedium(size: .labelFontSize)),
      .color(.labelColor),
      .alignment(.left)
    )
  }
  
  static var rightText: StringStyle {
    return StringStyle(
      .font(.circularStdBook(size: .labelFontSize)),
      .color(.secondaryLabelColor),
      .alignment(.right)
    )
  }
  
  static var bottomText: StringStyle {
    return StringStyle(
      .font(.circularStdBook(size: .smallSystemFontSize)),
      .color(.secondaryLabelColor),
      .alignment(.left)
    )
  }
  
  static var addingWidgetTitle: StringStyle {
    return StringStyle(
      .font(.circularStdBold(size: 23)),
      .color(.accentColor),
      .alignment(.center)
    )
  }
}

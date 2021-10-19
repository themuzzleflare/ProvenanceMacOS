import SwiftUI

struct AccountBalanceEntryView: View {
  @Environment(\.widgetFamily) private var family

  let entry: AccountBalanceProvider.Entry

  var body: some View {
    Group {
      if let account = entry.account {
        AccountBalanceView(family: family, account: account)
      } else if let error = entry.error {
        ErrorView(family: family, error: error)
      } else {
        Text("Edit widget to choose an account")
          .foregroundColor(.secondary)
          .padding()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .background(Color.widgetBackground)
    .font(.circularStdBook(size: 16))
  }
}

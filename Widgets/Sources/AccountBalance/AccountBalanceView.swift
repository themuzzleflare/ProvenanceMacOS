import SwiftUI
import WidgetKit

struct AccountBalanceView: View {
  let family: WidgetFamily
  let account: AccountBalanceModel

  var body: some View {
    switch family {
    case .systemSmall:
      VStack {
        Text(account.balance)
          .font(.circularStdBold(size: 20))
        Text(account.displayName)
      }
      .widgetURL("provenance://accounts/\(account.id)".url)
      .padding()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    case .systemMedium, .systemLarge:
      VStack {
        Text("Account Balance")
          .font(.circularStdBold(size: 23))
          .foregroundColor(.accentColor)
        Spacer()
        Text(account.balance)
          .font(.circularStdBold(size: 20))
        Text(account.displayName)
      }
      .widgetURL("provenance://accounts/\(account.id)".url)
      .padding()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    @unknown default:
      VStack {
        Text(account.balance)
          .font(.circularStdBold(size: 20))
        Text(account.displayName)
      }
      .widgetURL("provenance://accounts/\(account.id)".url)
      .padding()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}

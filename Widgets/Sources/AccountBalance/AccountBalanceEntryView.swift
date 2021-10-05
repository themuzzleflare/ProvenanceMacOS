import SwiftUI

struct AccountBalanceEntryView: View {
  @Environment(\.widgetFamily) private var family
  
  let entry: AccountBalanceProvider.Entry
  
  var body: some View {
    Group {
      if let account = entry.account {
        switch family {
        case .systemSmall:
          VStack {
            Text(account.balance)
              .font(.circularStdBold(size: 20))
            Text(account.displayName)
          }
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
          .padding()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        @unknown default:
          VStack {
            Text(account.balance)
              .font(.circularStdBold(size: 20))
            Text(account.displayName)
          }
          .padding()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      } else if let error = entry.error {
        switch family {
        case .systemSmall:
          Text(error.errorDescription ?? error.localizedDescription)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .systemMedium, .systemLarge:
          VStack {
            Text("Error")
              .font(.circularStdBold(size: 18))
            Text(error.errorDescription ?? error.localizedDescription)
          }
          .padding()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        @unknown default:
          VStack {
            Text("Error")
              .font(.circularStdBold(size: 18))
            Text(error.errorDescription ?? error.localizedDescription)
          }
          .padding()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
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

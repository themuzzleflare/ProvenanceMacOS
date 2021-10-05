import SwiftUI

struct LatestTransactionEntryView: View {
  @Environment(\.widgetFamily) private var family
  
  let entry: LatestTransactionProvider.Entry
  
  var body: some View {
    Group {
      if let transaction = entry.transaction {
        switch family {
        case .systemSmall:
          VStack {
            Text(transaction.description)
              .font(.circularStdBold(size: 20))
              .multilineTextAlignment(.center)
            Text(transaction.amount)
          }
          .padding()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .systemMedium, .systemLarge:
          VStack {
            Text("Latest Transaction")
              .font(.circularStdBold(size: 23))
              .foregroundColor(.accentColor)
            Spacer()
            TransactionCellView(transaction: transaction)
          }
          .padding()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        @unknown default:
          VStack {
            Text(transaction.description)
              .font(.circularStdBold(size: 20))
              .multilineTextAlignment(.center)
            Text(transaction.amount)
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
          Text(error.errorDescription ?? error.localizedDescription)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
    }
    .background(Color.widgetBackground)
    .font(.circularStdBook(size: 16))
  }
}

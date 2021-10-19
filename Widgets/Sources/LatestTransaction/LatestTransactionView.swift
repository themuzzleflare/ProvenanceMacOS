import SwiftUI
import WidgetKit

struct LatestTransactionView: View {
  let family: WidgetFamily
  let transaction: LatestTransactionModel

  var body: some View {
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
  }
}

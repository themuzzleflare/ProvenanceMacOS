import SwiftUI

struct LatestTransactionEntryView: View {
  @Environment(\.widgetFamily) private var family

  let entry: LatestTransactionProvider.Entry

  var body: some View {
    Group {
      if let transaction = entry.transaction {
        LatestTransactionView(family: family, transaction: transaction)
      } else if let error = entry.error {
        ErrorView(family: family, error: error)
      }
    }
    .background(Color.widgetBackground)
    .font(.circularStdBook(size: 16))
  }
}

import SwiftUI

struct TransactionCellView: View {
  let transaction: LatestTransactionModel
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(transaction.description)
          .font(.circularStdMedium(size: 15))
        Text(transaction.creationDate)
          .font(.circularStdBook(size: 11))
          .foregroundColor(.secondary)
      }
      .multilineTextAlignment(.leading)
      Spacer()
      Text(transaction.amount)
        .multilineTextAlignment(.trailing)
        .foregroundColor(transaction.colour.colour)
    }
  }
}

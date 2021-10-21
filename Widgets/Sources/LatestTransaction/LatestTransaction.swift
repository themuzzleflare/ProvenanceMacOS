import SwiftUI
import WidgetKit

struct LatestTransaction: Widget {
  var body: some WidgetConfiguration {
    IntentConfiguration(
      kind: Widgets.latestTransaction.kind,
      intent: DateStyleSelectionIntent.self,
      provider: LatestTransactionProvider(),
      content: { (entry) in
        LatestTransactionEntryView(entry: entry)
      }
    )
      .configurationDisplayName(Widgets.latestTransaction.name)
      .description(Widgets.latestTransaction.description)
      .supportedFamilies([.systemSmall, .systemMedium])
  }
}

struct LatestTransaction_Previews: PreviewProvider {
  static let families: [WidgetFamily] = [.systemSmall, .systemMedium]
  static var previews: some View {
    ForEach(families, id: \.self) { (family) in
      LatestTransactionEntryView(entry: .placeholder)
        .previewDisplayName(family.description)
        .previewContext(WidgetPreviewContext(family: family))
        .preferredColorScheme(.dark)
    }
  }
}

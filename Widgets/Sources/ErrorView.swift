import SwiftUI
import Alamofire
import WidgetKit

struct ErrorView: View {
  let family: WidgetFamily
  let error: AFError

  var body: some View {
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

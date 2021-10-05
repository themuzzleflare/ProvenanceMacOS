import Foundation

extension AddTagToTransactionIntentResponse {
  static func success(tags: [String], transaction: TransactionType, userActivity: NSUserActivity) -> AddTagToTransactionIntentResponse {
    let intentResponse = AddTagToTransactionIntentResponse(code: .success, userActivity: userActivity)
    intentResponse.tags = tags
    intentResponse.transaction = transaction
    return intentResponse
  }
}

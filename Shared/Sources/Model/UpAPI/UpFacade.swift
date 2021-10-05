import Alamofire

final class UpFacade {
  private static let jsonEncoder = JSONParameterEncoder.default
  
    /// Ping
    ///
    /// - Parameters:
    ///   - key: The personal access token to ping with.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Make a basic ping request to the API. This is useful to verify that authentication is functioning correctly. On authentication success an HTTP `200` status is returned. On failure an HTTP `401` error response is returned.
  
  static func ping(with key: String, completion: @escaping (AFError?) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: key)
    ]
    
    AF.request("https://api.up.com.au/api/v1/util/ping", method: .get, headers: headers)
      .validate()
      .response { (response) in
        completion(response.error)
      }
  }
  
    /// List transactions
    ///
    /// - Parameters:
    ///   - cursor: The pagination cursor to apply to the request.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Retrieve a list of all transactions across all accounts for the currently authenticated user. The returned list is [paginated](https://developer.up.com.au/#pagination) and can be scrolled by following the `next` and `prev` links where present. To narrow the results to a specific date range pass one or both of `filter[since]` and `filter[until]` in the query string. These filter parameters **should not** be used for pagination. Results are ordered newest first to oldest last.
  
  static func listTransactions(cursor: String? = nil, completion: @escaping (Result<[TransactionResource], AFError>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    var parameters: Parameters = [
      ParamKeys.pageSize: "20"
    ]
    
    if let cursor = cursor {
      parameters.updateValue(cursor, forKey: ParamKeys.pageAfter)
    }
    
    AF.request("https://api.up.com.au/api/v1/transactions", method: .get, parameters: parameters, headers: headers)
      .validate()
      .responseDecodable(of: Transaction.self) { (response) in
        switch response.result {
        case let .success(transactions):
          ProvenanceApp.userDefaults.paginationCursor = transactions.links.nextCursor ?? .emptyString
          completion(.success(transactions.data))
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
    /// List complete transactions
    ///
    /// - Parameters:
    ///   - cursor: The pagination cursor to apply to the request.
    ///   - inputTransactions: An array of `TransactionResource` objects to prepend to the response.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Retrieve a list of all transactions across all accounts for the currently authenticated user. To narrow the results to a specific date range pass one or both of `filter[since]` and `filter[until]` in the query string. These filter parameters **should not** be used for pagination. Results are ordered newest first to oldest last.
  
  static func listCompleteTransactions(cursor: String? = nil, inputTransactions: [TransactionResource] = [], completion: @escaping (Result<[TransactionResource], AFError>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    var parameters: Parameters = [
      ParamKeys.pageSize: "100"
    ]
    
    if let cursor = cursor {
      parameters.updateValue(cursor, forKey: ParamKeys.pageAfter)
    }
    
    AF.request("https://api.up.com.au/api/v1/transactions", method: .get, parameters: parameters, headers: headers)
      .validate()
      .responseDecodable(of: Transaction.self) { (response) in
        switch response.result {
        case let .success(transactions):
          if let nextCursor = transactions.links.nextCursor {
            print("Calling completion with cursor: \(nextCursor)")
            listCompleteTransactions(
              cursor: nextCursor,
              inputTransactions: (inputTransactions + transactions.data),
              completion: completion
            )
          } else {
            completion(.success(inputTransactions + transactions.data))
          }
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
    /// List transactions by account
    ///
    /// - Parameters:
    ///   - account: The account to list transactions for.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Retrieve a list of all transactions for a specific account. The returned list is [paginated](https://developer.up.com.au/#pagination) and can be scrolled by following the `next` and `prev` links where present. To narrow the results to a specific date range pass one or both of `filter[since]` and `filter[until]` in the query string. These filter parameters **should not** be used for pagination. Results are ordered newest first to oldest last.
  
  static func listTransactions(filterBy account: AccountResource, completion: @escaping (Result<[TransactionResource], AFError>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    let parameters: Parameters = [
      ParamKeys.pageSize: "100"
    ]
    
    AF.request("https://api.up.com.au/api/v1/accounts/\(account.id)/transactions", method: .get, parameters: parameters, headers: headers)
      .validate()
      .responseDecodable(of: Transaction.self) { (response) in
        switch response.result {
        case let .success(transactions):
          completion(.success(transactions.data))
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
    /// List transactions by tag
    ///
    /// - Parameters:
    ///   - tag: The tag to list transactions for.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Retrieve a list of all transactions for a specific tag. The returned list is [paginated](https://developer.up.com.au/#pagination) and can be scrolled by following the `next` and `prev` links where present. To narrow the results to a specific date range pass one or both of `filter[since]` and `filter[until]` in the query string. These filter parameters **should not** be used for pagination. Results are ordered newest first to oldest last.
  
  static func listTransactions(filterBy tag: TagResource, completion: @escaping (Result<[TransactionResource], AFError>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    let parameters: Parameters = [
      ParamKeys.filterTag: tag.id,
      ParamKeys.pageSize: "100"
    ]
    
    AF.request("https://api.up.com.au/api/v1/transactions", method: .get, parameters: parameters, headers: headers)
      .validate()
      .responseDecodable(of: Transaction.self) { (response) in
        switch response.result {
        case let .success(transactions):
          completion(.success(transactions.data))
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
    /// List transactions by category
    ///
    /// - Parameters:
    ///   - category: The category to list transactions for.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Retrieve a list of all transactions for a specific category. The returned list is [paginated](https://developer.up.com.au/#pagination) and can be scrolled by following the `next` and `prev` links where present. To narrow the results to a specific date range pass one or both of `filter[since]` and `filter[until]` in the query string. These filter parameters **should not** be used for pagination. Results are ordered newest first to oldest last.
  
  static func listTransactions(filterBy category: CategoryResource, completion: @escaping (Result<[TransactionResource], AFError>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    let parameters: Parameters = [
      ParamKeys.filterCategory: category.id,
      ParamKeys.pageSize: "100"
    ]
    
    AF.request("https://api.up.com.au/api/v1/transactions", method: .get, parameters: parameters, headers: headers)
      .validate()
      .responseDecodable(of: Transaction.self) { (response) in
        switch response.result {
        case let .success(transactions):
          completion(.success(transactions.data))
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
    /// Retrieve latest transaction
    ///
    /// - Parameter completion: Block to execute for handling the request response.
    ///
    /// Retrieve the latest transaction across all accounts.
  
  static func retrieveLatestTransaction(completion: @escaping (Result<TransactionResource, AFError>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    let parameters: Parameters = [
      ParamKeys.pageSize: "1"
    ]
    
    AF.request("https://api.up.com.au/api/v1/transactions", method: .get, parameters: parameters, headers: headers)
      .validate()
      .responseDecodable(of: Transaction.self) { (response) in
        switch response.result {
        case let .success(transactions):
          if let transaction = transactions.data.first {
            completion(.success(transaction))
          } else {
            completion(.failure(.responseValidationFailed(reason: .dataFileNil)))
          }
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
    /// Retrieve latest transaction for account
    ///
    /// - Parameters:
    ///   - account: The account to retrieve the latest transaction for.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Retrieve the latest transaction for a specific account.
  
  static func retrieveLatestTransaction(for account: AccountResource, completion: @escaping (Result<TransactionResource, AFError>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    let parameters: Parameters = [
      ParamKeys.pageSize: "1"
    ]
    
    AF.request("https://api.up.com.au/api/v1/accounts/\(account.id)/transactions", method: .get, parameters: parameters, headers: headers)
      .validate()
      .responseDecodable(of: Transaction.self) { (response) in
        switch response.result {
        case let .success(transactions):
          if let transaction = transactions.data.first {
            completion(.success(transaction))
          } else {
            completion(.failure(.responseValidationFailed(reason: .dataFileNil)))
          }
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
    /// Retrieve transaction
    ///
    /// - Parameters:
    ///   - transaction: The transaction to retrieve.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Retrieve a specific transaction by providing its unique identifier.
  
  static func retrieveTransaction(for transaction: TransactionResource, completion: @escaping (Result<TransactionResource, AFError>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    AF.request("https://api.up.com.au/api/v1/transactions/\(transaction.id)", method: .get, headers: headers)
      .validate()
      .responseDecodable(of: SingleTransaction.self) { (response) in
        switch response.result {
        case let .success(transaction):
          completion(.success(transaction.data))
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
    /// Retrieve transaction
    ///
    /// - Parameters:
    ///   - transactionId: The unique identifier for the transaction to retrieve.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Retrieve a specific transaction by providing its unique identifier.
  
  static func retrieveTransaction(for transactionId: String, completion: @escaping (Result<TransactionResource, AFError>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    AF.request("https://api.up.com.au/api/v1/transactions/\(transactionId)", method: .get, headers: headers)
      .validate()
      .responseDecodable(of: SingleTransaction.self) { (response) in
        switch response.result {
        case let .success(transaction):
          completion(.success(transaction.data))
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
    /// List accounts
    ///
    /// - Parameter completion: Block to execute for handling the request response.
    ///
    /// Retrieve a paginated list of all accounts for the currently authenticated user. The returned list is paginated and can be scrolled by following the `prev` and `next` links where present.
  
  static func listAccounts(completion: @escaping (Result<[AccountResource], AFError>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    let parameters: Parameters = [
      ParamKeys.pageSize: "100"
    ]
    
    AF.request("https://api.up.com.au/api/v1/accounts", method: .get, parameters: parameters, headers: headers)
      .validate()
      .responseDecodable(of: Account.self) { (response) in
        switch response.result {
        case let .success(accounts):
          completion(.success(accounts.data))
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
    /// Retrieve account
    ///
    /// - Parameters:
    ///   - account: The account to retrieve.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Retrieve a specific account by providing its unique identifier.
  
  static func retrieveAccount(for account: AccountResource, completion: @escaping (Result<AccountResource, AFError>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    AF.request("https://api.up.com.au/api/v1/accounts/\(account.id)", method: .get, headers: headers)
      .validate()
      .responseDecodable(of: SingleAccount.self) { (response) in
        switch response.result {
        case let .success(account):
          completion(.success(account.data))
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
    /// Retrieve account
    ///
    /// - Parameters:
    ///   - accountId: The unique identifier for the account to retrieve.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Retrieve a specific account by providing its unique identifier.
  
  static func retrieveAccount(for accountId: String, completion: @escaping (Result<AccountResource, AFError>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    AF.request("https://api.up.com.au/api/v1/accounts/\(accountId)", method: .get, headers: headers)
      .validate()
      .responseDecodable(of: SingleAccount.self) { (response) in
        switch response.result {
        case let .success(account):
          completion(.success(account.data))
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
    /// List tags
    ///
    /// - Parameter completion: Block to execute for handling the request response.
    ///
    /// Retrieve a list of all tags currently in use. The returned list is [paginated](https://developer.up.com.au/#pagination) and can be scrolled by following the `next` and `prev` links where present. Results are ordered lexicographically. The `transactions` relationship for each tag exposes a link to get the transactions with the given tag.
  
  static func listTags(completion: @escaping (Result<[TagResource], AFError>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    let parameters: Parameters = [
      ParamKeys.pageSize: "100"
    ]
    
    AF.request("https://api.up.com.au/api/v1/tags", method: .get, parameters: parameters, headers: headers)
      .validate()
      .responseDecodable(of: Tag.self) { (response) in
        switch response.result {
        case let .success(tags):
          completion(.success(tags.data))
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
    /// Add tags to transaction
    ///
    /// - Parameters:
    ///   - tags: The tags to add.
    ///   - transaction: The transaction to add the tags to.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Associates one or more tags with a specific transaction. No more than 6 tags may be present on any single transaction. Duplicate tags are silently ignored. An HTTP `204` is returned on success. The associated tags, along with this request URL, are also exposed via the `tags` relationship on the transaction resource returned from `/transactions/{id}`.
  
  static func modifyTags(adding tags: [TagResource], to transaction: TransactionResource, completion: @escaping (AFError?) -> Void) {
    let headers: HTTPHeaders = [
      .contentType("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    AF.request("https://api.up.com.au/api/v1/transactions/\(transaction.id)/relationships/tags", method: .post, parameters: ModifyTags(tags: tags), encoder: jsonEncoder, headers: headers)
      .validate()
      .response { (response) in
        completion(response.error)
      }
  }
  
    /// Add tags to transaction
    ///
    /// - Parameters:
    ///   - tags: The labels of the tags to add.
    ///   - transaction: The unique identifier for the transaction to add the tags to.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Associates one or more tags with a specific transaction. No more than 6 tags may be present on any single transaction. Duplicate tags are silently ignored. An HTTP `204` is returned on success. The associated tags, along with this request URL, are also exposed via the `tags` relationship on the transaction resource returned from `/transactions/{id}`.
  
  static func modifyTags(adding tags: [String], to transaction: String, completion: @escaping (AFError?) -> Void) {
    let headers: HTTPHeaders = [
      .contentType("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    AF.request("https://api.up.com.au/api/v1/transactions/\(transaction)/relationships/tags", method: .post, parameters: ModifyTags(tags: tags), encoder: jsonEncoder, headers: headers)
      .validate()
      .response { (response) in
        completion(response.error)
      }
  }
  
    /// Add tags to transaction
    ///
    /// - Parameters:
    ///   - tag: The tag to add.
    ///   - transaction: The transaction to add the tag to.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Associates one or more tags with a specific transaction. No more than 6 tags may be present on any single transaction. Duplicate tags are silently ignored. An HTTP `204` is returned on success. The associated tags, along with this request URL, are also exposed via the `tags` relationship on the transaction resource returned from `/transactions/{id}`.
  
  static func modifyTags(adding tag: TagResource, to transaction: TransactionResource, completion: @escaping (AFError?) -> Void) {
    let headers: HTTPHeaders = [
      .contentType("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    AF.request("https://api.up.com.au/api/v1/transactions/\(transaction.id)/relationships/tags", method: .post, parameters: ModifyTags(tag: tag), encoder: jsonEncoder, headers: headers)
      .validate()
      .response { (response) in
        completion(response.error)
      }
  }
  
    /// Remove tags from transaction
    ///
    /// - Parameters:
    ///   - tags: The tags to remove.
    ///   - transaction: The transaction to remove the tags from.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Disassociates one or more tags from a specific transaction. Tags that are not associated are silently ignored. An HTTP `204` is returned on success. The associated tags, along with this request URL, are also exposed via the `tags` relationship on the transaction resource returned from `/transactions/{id}`.
  
  static func modifyTags(removing tags: [TagResource], from transaction: TransactionResource, completion: @escaping (AFError?) -> Void) {
    let headers: HTTPHeaders = [
      .contentType("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    AF.request("https://api.up.com.au/api/v1/transactions/\(transaction.id)/relationships/tags", method: .delete, parameters: ModifyTags(tags: tags), encoder: jsonEncoder, headers: headers)
      .validate()
      .response { (response) in
        completion(response.error)
      }
  }
  
    /// Remove tags from transaction
    ///
    /// - Parameters:
    ///   - tags: The labels of the tags to remove.
    ///   - transaction: The unique identifier for the transaction to remove the tags from.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Disassociates one or more tags from a specific transaction. Tags that are not associated are silently ignored. An HTTP `204` is returned on success. The associated tags, along with this request URL, are also exposed via the `tags` relationship on the transaction resource returned from `/transactions/{id}`.
  
  static func modifyTags(removing tags: [String], from transaction: String, completion: @escaping (AFError?) -> Void) {
    let headers: HTTPHeaders = [
      .contentType("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    AF.request("https://api.up.com.au/api/v1/transactions/\(transaction)/relationships/tags", method: .delete, parameters: ModifyTags(tags: tags), encoder: jsonEncoder, headers: headers)
      .validate()
      .response { (response) in
        completion(response.error)
      }
  }
  
    /// Remove tags from transaction
    ///
    /// - Parameters:
    ///   - tag: The tag to remove.
    ///   - transaction: The transaction to remove the tag from.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Disassociates one or more tags from a specific transaction. Tags that are not associated are silently ignored. An HTTP `204` is returned on success. The associated tags, along with this request URL, are also exposed via the `tags` relationship on the transaction resource returned from `/transactions/{id}`.
  
  static func modifyTags(removing tag: TagResource, from transaction: TransactionResource, completion: @escaping (AFError?) -> Void) {
    let headers: HTTPHeaders = [
      .contentType("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    AF.request("https://api.up.com.au/api/v1/transactions/\(transaction.id)/relationships/tags", method: .delete, parameters: ModifyTags(tag: tag), encoder: jsonEncoder, headers: headers)
      .validate()
      .response { (response) in
        completion(response.error)
      }
  }
  
    /// List categories
    ///
    /// - Parameter completion: Block to execute for handling the request response.
    ///
    /// Retrieve a list of all categories and their ancestry. The returned list is not paginated.
  
  static func listCategories(completion: @escaping (Result<[CategoryResource], AFError>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    AF.request("https://api.up.com.au/api/v1/categories", method: .get, headers: headers)
      .validate()
      .responseDecodable(of: Category.self) { (response) in
        switch response.result {
        case let .success(categories):
          completion(.success(categories.data))
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
    /// Retrieve category
    ///
    /// - Parameters:
    ///   - category: The category to retrieve.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Retrieve a specific category by providing its unique identifier.
  
  static func retrieveCategory(for category: CategoryResource, completion: @escaping (Result<CategoryResource, AFError>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    AF.request("https://api.up.com.au/api/v1/categories/\(category.id)", method: .get, headers: headers)
      .validate()
      .responseDecodable(of: SingleCategory.self) { (response) in
        switch response.result {
        case let .success(category):
          completion(.success(category.data))
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
    /// Retrieve category
    ///
    /// - Parameters:
    ///   - categoryId: The unique identifier for the category to retrieve.
    ///   - completion: Block to execute for handling the request response.
    ///
    /// Retrieve a specific category by providing its unique identifier.
  
  static func retrieveCategory(for categoryId: String, completion: @escaping (Result<CategoryResource, AFError>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json"),
      .authorization(bearerToken: ProvenanceApp.userDefaults.apiKey)
    ]
    
    AF.request("https://api.up.com.au/api/v1/categories/\(categoryId)", method: .get, headers: headers)
      .validate()
      .responseDecodable(of: SingleCategory.self) { (response) in
        switch response.result {
        case let .success(category):
          completion(.success(category.data))
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
}

extension UpFacade {
  struct ParamKeys {
      /// The number of records to return in each page.
    static let pageSize = "page[size]"
    
      /// The transaction status for which to return records. This can be used to filter `HELD` transactions from those that are `SETTLED`.
    static let filterStatus = "filter[status]"
    
      /// The start date-time from which to return records, formatted according to rfc-3339. Not to be used for pagination purposes.
    static let filterSince = "filter[since]"
    
      /// The end date-time up to which to return records, formatted according to rfc-3339. Not to be used for pagination purposes.
    static let filterUntil = "filter[until]"
    
      /// The category identifier for which to filter transactions. Both parent and child categories can be filtered through this parameter. Providing an invalid category identifier results in a `404` response.
    static let filterCategory = "filter[category]"
    
      /// The unique identifier of a parent category for which to return only its children. Providing an invalid category identifier results in a `404` response.
    static let filterParent = "filter[parent]"
    
      /// A transaction tag to filter for which to return records. If the tag does not exist, zero records are returned and a success response is given.
    static let filterTag = "filter[tag]"
    
    static let pageBefore = "page[before]"
    
    static let pageAfter = "page[after]"
  }
}

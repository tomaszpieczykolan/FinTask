//
//  API.swift
//  FinTask
//
//  Created by Tomasz Pieczykolan on 07/06/2018.
//  Copyright © 2018 Tomasz Pieczykolan. All rights reserved.
//

import struct Foundation.URL

/// Abstracts requests to external APIs
class API {
    
    /// HTTP client
    private let rest: Rest
    
    /// Shared instance of `API`
    ///
    /// Uses `Rest.shared` as it's HTTP client
    static let shared = API(rest: .shared)
    
    
    
    // MARK: - Lifecycle
    
    init(rest: Rest) {
        self.rest = rest
    }
    
    
    
    // MARK: - Requests
    
    func getDailymotionUsers(successHandler: @escaping ([DailymotionUser]) -> Void, errorHandler: @escaping (Swift.Error) -> Void) {
        guard let url = URL(string: Endpoint.dailymotionUsers) else {
            errorHandler(Error.badEndpoint)
            return
        }
        rest.get(from: url, successHandler: { (dailymotionResponse: DailymotionResponse) in
            successHandler(dailymotionResponse.list)
        }, errorHandler: errorHandler)
    }
    
    func getGitHubUsers(successHandler: @escaping ([GitHubUser]) -> Void, errorHandler: @escaping (Swift.Error) -> Void) {
        guard let url = URL(string: Endpoint.gitHubUsers) else {
            errorHandler(Error.badEndpoint)
            return
        }
        rest.get(from: url, successHandler: successHandler, errorHandler: errorHandler)
    }
    
    
    
    // MARK: - Errors
    
    enum Error: Swift.Error {
        case badEndpoint
    }
}

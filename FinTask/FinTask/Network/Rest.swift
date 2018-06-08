//
//  Rest.swift
//  FinTask
//
//  Created by Tomasz Pieczykolan on 05/06/2018.
//  Copyright © 2018 Tomasz Pieczykolan. All rights reserved.
//

import Foundation

/// HTTP Client
///
/// Use `shared` instance or create your own
final class Rest {
    
    /// Shared instance of `Rest`
    ///
    /// Uses `URLSession.shared` as it's session
    static let shared = Rest(session: .shared, decoder: JSONDecoder())
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    
    
    // MARK: - Lifecycle
    
    init(session: URLSession, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }
    
    
    
    // MARK: - Requests
    
    /// Basic GET request
    ///
    /// - parameters:
    ///     - url: request URL
    ///     - successHandler: block that will be called if everything goes right
    ///     - errorHandler: block that will be called if any error occurs
    func get(from url: URL, successHandler: @escaping (Data) -> Void, errorHandler: @escaping (Swift.Error) -> Void) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            do {
                if let unwrappedError = error {
                    throw unwrappedError
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw Error.cannotCastResponse
                }
                guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                    throw Error.badResponse(statusCode: httpResponse.statusCode)
                }
                guard let unwrappedData = data else {
                    throw Error.missingData
                }
                successHandler(unwrappedData)
            } catch {
                errorHandler(error)
            }
        })
        task.resume()
    }
    
    /// Generic GET request that outputs models conforming to `Decodable`
    ///
    /// - parameters:
    ///     - url: request URL
    ///     - successHandler: block that will be called if everything goes right
    ///     - errorHandler: block that will be called if any error occurs
    func get<T: Decodable>(from url: URL, successHandler: @escaping (T) -> Void, errorHandler: @escaping (Swift.Error) -> Void) {
        get(from: url, successHandler: { data in
            do {
                let decodable = try self.decoder.decode(T.self, from: data)
                successHandler(decodable)
            } catch {
                errorHandler(error)
            }
        }, errorHandler: errorHandler)
    }
    
    
    
    // MARK: - Errors
    
    enum Error: Swift.Error {
        case missingData
        case cannotCastResponse
        case badResponse(statusCode: Int)
    }
}

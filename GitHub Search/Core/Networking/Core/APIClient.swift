//
//  APIClient.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 08. 30..
//

import Foundation
import PromiseKit
import SwiftyJSON

final class APIClient {

    // MARK: Public Properties
    
    static let shared = APIClient()
    
    // MARK: Private Properties
    
    // Usually this would be set depending on the build configuration,
    // however it's not relevant as the GitHub API is a third-party service.
    private let host = "api.github.com"
    
    private let urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"]
        return URLSession(configuration: config)
    }()
    
    // MARK: Public Methods
    
    func execute<Request: APIRequest>(_ request: Request) -> Promise<Request.Result> {
        Promise { seal in
            firstly {
                urlSession.dataTask(.promise, with: buildURLRequest(from: request))
            }.done {
                seal.fulfill(try request.responseParser.parse($0.data))
            }.catch(policy: .allErrors) {
                do {
                    try APIErrorHandler.handle($0, request: request)
                    // Error was handled the by the error handler, so cancel the promise chain.
                    seal.reject(PMKError.cancelled)
                } catch {
                    // Error was not handled by the error handler, so forward it to the caller.
                    seal.reject($0)
                }
            }
        }
    }
    
    // MARK: Private Methods
    
    private func urlFor<T: APIRequest>(request: T) -> URL {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.scheme = "https"
        urlComponents.path = request.endpoint
        urlComponents.queryItems = request.queryItems?.compactMap {
            if $0.value != nil && !$0.value!.isEmpty {
                return URLQueryItem(name: $0.key, value: $0.value)
            }
            return nil
        }
        return urlComponents.url!
    }
    
    private func buildURLRequest<T: APIRequest>(from request: T) -> URLRequest {
        var urlRequest = URLRequest(url: urlFor(request: request))
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        return urlRequest
    }
    
}

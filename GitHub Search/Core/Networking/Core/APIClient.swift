//
//  APIClient.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import Foundation
import PromiseKit
import SwiftyJSON

final class APIClient {
    
    // MARK: Nested Types
    
    enum Error: Swift.Error {
        
        case httpError(url: URL, errorCode: Int, body: Data)
        
    }

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
                urlSession.dataTask(.promise, with: buildURLRequest(from: request)).validateResponse()
            }.done {
                seal.fulfill(try request.responseParser.parse($0.data, response: $0.response as! HTTPURLResponse))
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
        // If the request's URI is already a valid URL, use that instead of building one.
        if request.uri.isValidURL,
           let url = URL(string: request.uri),
           var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = request.queryItems?.compactMap {
                if $0.value != nil && !$0.value!.isEmpty {
                    return URLQueryItem(name: $0.key, value: $0.value)
                }
                return nil
            }
            return urlComponents.url!
        }
        
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.scheme = "https"
        urlComponents.path = request.uri
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

// MARK: String

fileprivate extension String {
    
    var isValidURL: Bool {
        guard let url = URL(string: self) else { return false }
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return urlComponents?.scheme != nil && urlComponents?.host != nil
    }
    
}

// MARK: Promise

private extension Promise where T == (data: Data, response: URLResponse) {
    
    // MARK: Public Methods

    func validateResponse() -> Promise<T> {
        map {
            let response = $0.response as! HTTPURLResponse
            if response.statusCode > 300 {
                throw APIClient.Error.httpError(url: response.url!, errorCode: response.statusCode, body: $0.data)
            }
            return $0
        }
    }
    
}

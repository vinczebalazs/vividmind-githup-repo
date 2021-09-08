//
//  SearchRepositoriesNextPageRequest.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import Foundation

final class SearchRepositoriesNextPageRequest: APIRequest {

    // MARK: Nested Types

    typealias Result = SearchRepositoriesResponse
    
    // MARK: Public Properties
    
    let uri: String
    let method: HTTPMethod = .get
    let queryItems: [String: String?]?
    let body: Data? = nil
    let responseParser: ResponseParser<SearchRepositoriesResponse>.Type = SearchRepositoriesResponseParser.self

    // MARK: Initializers
    
    init(url: URL) {
        uri = url.absoluteString
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        queryItems = urlComponents.queryItems?.reduce(into: [String: String]()) {
            $0[$1.name] = $1.value
        }
    }
    
}

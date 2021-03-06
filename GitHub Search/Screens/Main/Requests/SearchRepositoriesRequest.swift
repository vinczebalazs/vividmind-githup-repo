//
//  SearchRepositoriesRequest.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import Foundation

final class SearchRepositoriesRequest: APIRequest {

    // MARK: Nested Types

    typealias Result = SearchRepositoriesResponse
    
    // MARK: Public Properties
    
    let uri = "/search/repositories"
    let method: HTTPMethod = .get
    let queryItems: [String: String?]?
    let body: Data? = nil
    let responseParser: ResponseParser<SearchRepositoriesResponse>.Type = SearchRepositoriesResponseParser.self

    // MARK: Initializers
    
    init(query: String) {
        queryItems = ["q": query]
    }
    
}

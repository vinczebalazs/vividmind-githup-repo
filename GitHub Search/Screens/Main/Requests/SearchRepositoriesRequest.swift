//
//  SearchRepositoriesRequest.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import Foundation

final class SearchRepositoriesRequest: APIRequest {

    // MARK: Nested Types

    typealias Result = [Repository]
    
    // MARK: Public Properties
    
    let endpoint = "/search/repositories"
    let method: HTTPMethod = .get
    let queryItems: [String: String?]?
    let body: Data? = nil
    let responseParser: ResponseParser<[Repository]>.Type = SearchRepositoriesResponseParser.self

    // MARK: Initializers
    
    init(query: String) {
        queryItems = ["q": query]
    }
    
}

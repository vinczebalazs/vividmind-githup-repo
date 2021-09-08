//
//  SearchRepositoriesResponseParser.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import SwiftyJSON

final class SearchRepositoriesResponseParser: ResponseParser<SearchRepositoriesResponse> {
    
    // MARK: Nested Types
    
    enum Error: Swift.Error {
        
        case errorParsingNextPageLink
        
    }
    
    // MARK: Static Public Methods
    
    override class func parse(_ data: Data, response: HTTPURLResponse) throws -> SearchRepositoriesResponse {
        let json = try JSON(data: data)
        guard let itemsArray = json["items"].array else {
            throw ResponseParsingError.keyNotFound(key: "items")
        }
        return SearchRepositoriesResponse(nextPageURL: try getNextPageLink(response),
                                          items: try itemsArray.map { try Repository($0) })
    }
    
    // MARK: Static Private Methods
    
    private static func getNextPageLink(_ response: HTTPURLResponse) throws -> URL? {
        guard let linkHeader = response.value(forHTTPHeaderField: "Link") else {
            return nil
        }
        
        let links = linkHeader.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        guard let nextPageURLGroup = links.first(where: {
            $0.contains("rel=\"next\"")
        }) else {
            return nil
        }
        
        guard let endIndex = nextPageURLGroup.firstIndex(of: ">") else {
            throw Error.errorParsingNextPageLink
        }
                
        let startIndex = nextPageURLGroup.index(nextPageURLGroup.startIndex, offsetBy: 1)
        let link = String(nextPageURLGroup[startIndex..<endIndex])
        guard let nextPageURL = URL(string: link) else {
            throw Error.errorParsingNextPageLink
        }
        return nextPageURL
    }
    
}

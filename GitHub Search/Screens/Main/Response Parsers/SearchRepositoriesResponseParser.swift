//
//  SearchRepositoriesResponseParser.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import SwiftyJSON

final class SearchRepositoriesResponseParser: ResponseParser<[Repository]> {
    
    // MARK: Static Public Methods
    
    override class func parse(_ data: Data) throws -> [Repository] {
        let json = try JSON(data: data)
        guard let items = json["items"].array else {
            throw ResponseParsingError.keyNotFound(key: "items")
        }
        return try items.map { try Repository($0) }
    }
    
}

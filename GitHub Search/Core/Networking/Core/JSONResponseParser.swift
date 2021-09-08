//
//  JSONResponseParser.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import SwiftyJSON

final class JSONResponseParser<T: JSONDecodable>: ResponseParser<T> {
    
    // MARK: Static Public Methods
    
    override class func parse(_ data: Data, response: HTTPURLResponse) throws -> T {
        try T(try JSON(data: data))
    }
    
}

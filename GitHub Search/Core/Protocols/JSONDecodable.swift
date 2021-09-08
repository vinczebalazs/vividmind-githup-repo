//
//  JSONDecodable.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 08. 30..
//

import Foundation
import SwiftyJSON

protocol JSONDecodable {
    
    // MARK: Initializers
    
    init(_ json: JSON) throws
    
}

extension Array: JSONDecodable where Iterator.Element: JSONDecodable {
    
    // MARK: Nested Types
    
    enum Error: Swift.Error {
        
        case notAnArray
        
    }
    
    // MARK: Initializers
    
    init(_ json: JSON) throws {
        guard let array = json.array else {
            throw Error.notAnArray
        }
        
        self = try array.map { try Iterator.Element($0) }
    }

}

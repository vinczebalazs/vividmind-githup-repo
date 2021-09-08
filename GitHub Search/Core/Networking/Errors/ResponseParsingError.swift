//
//  ResponseParsingError.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 08. 30..
//

import Foundation

enum ResponseParsingError: Error, CustomStringConvertible {
    
    // MARK: Cases
    
    case general(file: String = #file, message: String)
    case keyNotFound(file: String = #file, key: String)
    
    // MARK: Public Properties
    
    var description: String {
        switch self {
        case .general(let file, let message):
            return "\(file):Failed to parse response. \(message)"
        case .keyNotFound(let file, let key):
            return "\(file): Failed to parse response, key not found: \(key)"
        }
    }
    
}

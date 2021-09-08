//
//  APIRequest.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 08. 30..
//

import Foundation

protocol APIRequest {
    
    // MARK: Nested Types
    
    associatedtype Result
    
    // MARK: Properties
    
    var uri: String { get }
    var method: HTTPMethod { get }
    var queryItems: [String: String?]? { get }
    var body: Data? { get }
    var responseParser: ResponseParser<Result>.Type { get }

}

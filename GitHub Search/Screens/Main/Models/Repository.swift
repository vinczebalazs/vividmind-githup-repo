//
//  Repository.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 08. 30..
//

import Foundation
import SwiftyJSON

struct Repository: JSONDecodable {
    
    // MARK: Public Properties
    
    let description: String?
    let htmlURL: URL
    let name: String
    let numberOfStars: Int
    let ownerAvatar: URL
    let ownerName: String
    
    // MARK: Initializers
    
    init(_ json: JSON) throws {
        guard let name = json["name"].string else {
            throw ResponseParsingError.keyNotFound(key: "name")
        }
        guard let numberOfStars = json["stargazers_count"].int else {
            throw ResponseParsingError.keyNotFound(key: "stargazers_count")
        }
        guard let ownerAvatarString = json["owner"]["avatar_url"].string else {
            throw ResponseParsingError.keyNotFound(key: "owner.avatar_url")
        }
        guard let ownerAvatar = URL(string: ownerAvatarString) else {
            throw ResponseParsingError.general(message: "owner.avatar_url is not a valid URL.")
        }
        guard let ownerName = json["owner"]["login"].string else {
            throw ResponseParsingError.keyNotFound(key: "owner.login")
        }
        guard let htmlURLString = json["html_url"].string else {
            throw ResponseParsingError.keyNotFound(key: "html_url")
        }
        guard let htmlURL = URL(string: htmlURLString) else {
            throw ResponseParsingError.general(message: "html_url is not a valid URL.")
        }
        
        self.description = json["description"].string
        self.name = name
        self.numberOfStars = numberOfStars
        self.ownerAvatar = ownerAvatar
        self.ownerName = ownerName
        self.htmlURL = htmlURL
    }
    
}

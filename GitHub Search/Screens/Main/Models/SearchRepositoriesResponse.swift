//
//  SearchRepositoriesResponse.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import Foundation

struct SearchRepositoriesResponse {
    
    // MARK: Public Properties
    
    let nextPageURL: URL?
    let items: [Repository]
    
}

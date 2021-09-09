//
//  MainPresenterType.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 09..
//

import Foundation

protocol MainPresenterType {
    
    // MARK: Properties
    
    var repositories: [Repository] { get }
    var nextPageURL: URL?  { get }
    var hasNextPage: Bool { get }
    var onSearchFinished: ((Swift.Result<Void, Error>) -> ())?  { get set }
    var onLoadNextPageFinished: ((Swift.Result<Void, Error>) -> ())?  { get set }
            
    // MARK: Methods
    
    func searchRepositories(query: String)
    func loadNextPage()
    func clearSearch()
    
}

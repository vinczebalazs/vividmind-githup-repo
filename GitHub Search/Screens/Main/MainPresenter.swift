//
//  MainPresenter.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import PromiseKit

final class MainPresenter {
    
    // MARK: Public Properties
    
    var repositories = [Repository]()
    var nextPageURL: URL?
    var hasNextPage: Bool {
        nextPageURL != nil
    }
            
    // MARK: Public Methods
    
    func searchRepositories(query: String) -> Promise<Void> {
        APIClient.shared.execute(SearchRepositoriesRequest(query: query)).then { [self] result -> Promise<Void> in
            repositories = result.items
            nextPageURL = result.nextPageURL
            return Promise { $0.fulfill_() }
        }
    }
    
    func loadNextPage() -> Promise<Void> {
        guard let nextPageURL = nextPageURL else {
            fatalError("No next page. Use hasNextPage to check prior to calling this method.")
        }
        return APIClient.shared.execute(SearchRepositoriesNextPageRequest(url: nextPageURL))
            .then { result -> Promise<Void> in
                self.repositories += result.items
                self.nextPageURL = result.nextPageURL
                return Promise { $0.fulfill_() }
            }
    }
    
}

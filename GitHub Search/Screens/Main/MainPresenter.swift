//
//  MainPresenter.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

import PromiseKit

final class MainPresenter: MainPresenterType {
    
    // MARK: Public Properties
    
    var repositories = [Repository]()
    var nextPageURL: URL?
    var hasNextPage: Bool {
        nextPageURL != nil
    }
    var onSearchFinished: ((Swift.Result<Void, Error>) -> ())?
    var onLoadNextPageFinished: ((Swift.Result<Void, Error>) -> ())?
            
    // MARK: Public Methods
    
    func searchRepositories(query: String) {
        APIClient.shared.execute(SearchRepositoriesRequest(query: query)).done { [self] in
            repositories = $0.items
            nextPageURL = $0.nextPageURL
            onSearchFinished?(.success(()))
        }.catch {
            self.onSearchFinished?(.failure($0))
        }
    }
    
    func loadNextPage() {
        guard let nextPageURL = nextPageURL else {
            fatalError("No next page. Use hasNextPage to check prior to calling this method.")
        }
        
        APIClient.shared.execute(SearchRepositoriesNextPageRequest(url: nextPageURL)).done {
            self.repositories += $0.items
            self.nextPageURL = $0.nextPageURL
            self.onLoadNextPageFinished?(.success(()))
        }.catch {
            self.onLoadNextPageFinished?(.failure($0))
        }
    }
    
    func clearSearch() {
        repositories = []
        nextPageURL = nil
    }
    
}

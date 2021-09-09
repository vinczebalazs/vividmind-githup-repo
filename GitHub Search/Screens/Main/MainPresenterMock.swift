//
//  MainPresenterMock.swift
//  GitHub Search
//
//  Created by Balazs Vincze on 2021. 09. 09..
//

import PromiseKit

final class MainPresenterMock: MainPresenterType {
    
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
        let response = buildMockResponse(includeNextPageLink: true)
        repositories += response.items
        nextPageURL = response.nextPageURL
        after(seconds: 1).done {
            self.onSearchFinished?(.success(()))
        }
    }
    
    func loadNextPage() {
        precondition(nextPageURL != nil)
        
        let response = buildMockResponse(includeNextPageLink: false)
        repositories += response.items
        nextPageURL = response.nextPageURL
        after(seconds: 1).done {
            self.onLoadNextPageFinished?(.success(()))
        }
    }
    
    func clearSearch() {
        repositories = []
        nextPageURL = nil
    }
    
    // MARK: Private Methods
    
    private func buildMockResponse(includeNextPageLink: Bool) -> SearchRepositoriesResponse {
        var headers = ["Content-Type": "application/json"]
        if includeNextPageLink {
            headers["Link"] = "<https://api.github.com/search/repositories?q=query&page=2>; rel=\"next\", <https://api.github.com/search/repositories?q=query&page=34>; rel=\"last\""
        }
        
        let response = HTTPURLResponse(url: URL(string: "https://api.github.com")!,
                                      statusCode: 200,
                                      httpVersion: nil,
                                      headerFields: headers)!
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "mockSearchResponse", withExtension: "json")!)
        return try! SearchRepositoriesResponseParser.parse(data, response: response)
    }
    
}

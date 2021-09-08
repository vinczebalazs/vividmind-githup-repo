//
//  MainPresenterTests.swift
//  GitHub SearchTests
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

@testable import GitHub_Search
import Quick
import Nimble
import OHHTTPStubs

// swiftlint:disable function_body_length
final class MainPresenterTests: QuickSpec {
    
    // MARK: Public Methods
    
    override func spec() {
        afterEach {
            HTTPStubs.removeAllStubs()
        }
        
        it("returns search results correctly") {
            let presenter = MainPresenter()
            
            // Stub the search request.
            stub(condition: pathMatches("search/repositories")) { _ in
                fixture(filePath: OHPathForFile("mockSearchResponse.json", type(of: self))!,
                        headers: ["Content-Type":"application/json"])
            }
            
            // Perform the search request.
            let exp1 = QuickSpec.current.expectation(description: "Search request finished.")
            presenter.onSearchFinished = {
                exp1.fulfill()
                if case let .failure(error) = $0 {
                    print(error)
                    fatalError()
                }
            }
            presenter.searchRepositories(query: "query")
            QuickSpec.current.waitForExpectations(timeout: 2)
            
            // Check the number of items.
            expect(presenter.repositories.count) == 8
            
            // Check if the first item is what we expect it to be.
            let first = presenter.repositories[0]
            expect(first.name) == "SCLAlertView-Swift"
            expect(first.ownerName) == "vikmeup"
            expect(first.ownerAvatarURL) == URL(string: "https://avatars.githubusercontent.com/u/1641795?v=4")
            expect(first.description) == "Beautiful animated Alert View. Written in Swift"
            expect(first.htmlURL) == URL(string: "https://github.com/vikmeup/SCLAlertView-Swift")
            expect(first.numberOfStars) == 5158
        }
        
        it("handles pagination correctly") {
            let presenter = MainPresenter()
            
            // Stub the search request.
            stub(condition: pathMatches("search/repositories")) { _ in
                fixture(filePath: OHPathForFile("mockSearchResponse.json", type(of: self))!,
                        headers: ["Content-Type":"application/json",
                                  "Link": "<https://api.github.com/search/repositories?q=query&page=2>; rel=\"next\", <https://api.github.com/search/repositories?q=query&page=34>; rel=\"last\""])
            }
            
            // Perform the search request.
            let exp1 = QuickSpec.current.expectation(description: "Search request finished.")
            presenter.onSearchFinished = {
                exp1.fulfill()
                if case let .failure(error) = $0 {
                    print(error)
                    fatalError()
                }
            }
            presenter.searchRepositories(query: "query")
            QuickSpec.current.waitForExpectations(timeout: 2)
            
            let nextPageURL = "https://api.github.com/search/repositories?q=query&page=2"

            // Check if the nextPageURL is parsed correctly.
            expect(presenter.nextPageURL?.absoluteString) == nextPageURL
            
            // Stub the next page request.
            stub(condition: pathMatches("search/repositories")) { _ in
                fixture(filePath: OHPathForFile("mockSearchResponse.json", type(of: self))!,
                        headers: ["Content-Type":"application/json"])
            }
            
            
            let firstRequestRepositoryCount = presenter.repositories.count
            
            // Perform the next page request.
            let exp2 = QuickSpec.current.expectation(description: "Next page request finished.")
            presenter.onLoadNextPageFinished = {
                exp2.fulfill()
                if case let .failure(error) = $0 {
                    print(error)
                    fatalError()
                }
            }
            presenter.loadNextPage()
            QuickSpec.current.waitForExpectations(timeout: 2)
            
            // Check if the results are appended correctly.
            expect(firstRequestRepositoryCount * 2) == presenter.repositories.count
            expect(presenter.repositories[0]) == presenter.repositories[firstRequestRepositoryCount]
        }
        
    }

}

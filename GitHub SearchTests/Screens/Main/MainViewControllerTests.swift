//
//  MainViewControllerTests.swift
//  GitHub SearchTests
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

@testable import GitHub_Search
import Quick
import SnapshotTesting
import OHHTTPStubs
import PromiseKit

// swiftlint:disable function_body_length
final class MainViewControllerTests: QuickSpec {
    
    // MARK: Public Methods
    
    override func spec() {
        afterEach {
            HTTPStubs.removeAllStubs()
        }
        
        it("renders search results correctly") {
            let presenter = MainPresenter()
            let exp = QuickSpec.current.expectation(description: "Search finished.")
            let vc = MainViewController(presenter: presenter)

            presenter.onSearchFinished = { _ in
                assertSnapshot(matching: vc, as: .recursiveDescription(on: .iPhoneX))
                exp.fulfill()
            }

            stub(condition: pathMatches("search/repositories")) { _ in
                fixture(filePath: OHPathForFile("mockSearchResponse.json", type(of: self))!,
                        headers: ["Content-Type":"application/json"])
            }

            presenter.searchRepositories(query: "")
            QuickSpec.current.waitForExpectations(timeout: 2)
        }
    }

}

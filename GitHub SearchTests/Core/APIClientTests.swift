//
//  APIClientTests.swift
//  GitHub SearchTests
//
//  Created by Balazs Vincze on 2021. 08. 30..
//

@testable import GitHub_Search
import Quick
import Nimble
import OHHTTPStubs

// swiftlint:disable function_body_length
final class APIClientTests: QuickSpec {
    
    // MARK: Public Methods
    
    override func spec() {
        afterEach {
            HTTPStubs.removeAllStubs()
        }
                
        it("executes a request correctly") {
            let exp = QuickSpec.current.expectation(description: "Wait for request to finish.")
            let url = "https://api.github.com/search/repositories?q=SCLAlertView-Swift"
            stub(condition: isAbsoluteURLString(url)) { _ in
                fixture(filePath: OHPathForFile("mockSearchResponse.json", type(of: self))!,
                        headers: ["Content-Type":"application/json"])
            }
            APIClient.shared.execute(SearchRepositoriesRequest(query: "SCLAlertView-Swift")).ensure {
                exp.fulfill()
            }.cauterize()
            QuickSpec.current.waitForExpectations(timeout: 2)
        }
    }

}

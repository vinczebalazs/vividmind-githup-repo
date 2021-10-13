//
//  MainViewControllerTests.swift
//  GitHub SearchTests
//
//  Created by Balazs Vincze on 2021. 09. 08..
//

@testable import GitHub_Search
import Quick
import Nimble
import OHHTTPStubs
import PromiseKit
import Foundation

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
            vc.beginAppearanceTransition(true, animated: false)
            vc.endAppearanceTransition()
            

            presenter.onSearchFinished = {
                vc.searchFinished($0)
                exp.fulfill()
            }

            stub(condition: pathMatches("search/repositories")) { _ in
                fixture(filePath: OHPathForFile("mockSearchResponse.json", type(of: self))!,
                        headers: ["Content-Type":"application/json"])
            }

            presenter.searchRepositories(query: "")
            QuickSpec.current.waitForExpectations(timeout: 2)
            
            expect(vc.title) == "GitHub Search"
            
            expect(vc.tableView.dataSource!.tableView(vc.tableView, numberOfRowsInSection: 0)) == 14
            
            let firstCell = vc.tableView.dataSource!.tableView(vc.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
                as! MainTableViewCell
            expect(firstCell.nameLabel.text) == "SCLAlertView-Swift"
            expect(firstCell.ownerLabel.text) == "vikmeup"
            expect(firstCell.starCountLabel.text) == "5158"
            expect(firstCell.descriptionLabel.text) == "Beautiful animated Alert View. Written in Swift"
        }
    }

}

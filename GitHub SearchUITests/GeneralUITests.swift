//
//  GeneralUITests.swift
//  GitHub SearchUITests
//
//  Created by Balazs Vincze on 2021. 08. 30..
//

import XCTest
import Nimble

final class GeneralUITests: XCTestCase {
        
    // MARK: Private Properties
    
    private let app = XCUIApplication()
    
    // MARK: Public Methods
         
    func testFirstCellContents() {
        // Launch the app.
        app.launchArguments = ["-uitest"]
        app.launch()
        
        // Search for "SCLAlertView"
        let searchField = app.searchFields["Search"]
        searchField.tap()
        searchField.typeText("SCLAlertView")
        searchField.typeText(XCUIKeyboardKey.return.rawValue)
        
        // Expect the first cell's contents to be populated correctly.
        let firstCell = app.tables.element(boundBy: 0).cells.element(boundBy: 0)
        expect(firstCell.waitForExistence(timeout: 1)).to(beTrue())
        expect(firstCell.staticTexts["title"].label) == "SCLAlertView-Swift"
        expect(firstCell.staticTexts["owner"].label) == "vikmeup"
        expect(firstCell.staticTexts["starCount"].label) == "5158"
        expect(firstCell.staticTexts["description"].label) == "Beautiful animated Alert View. Written in Swift"
    }
        
    func testLoadingNextPage() {
        // Scroll to the last cell.
        let lastCell = app.tables.element(boundBy: 0).cells.element(boundBy: 13)
        while !lastCell.isHittable {
            app.swipeUp()
        }

        // * Unfortunately I could not get this to work, it could not find the element by it's id. *
        // Expect the activity indicator to be visible.
//        expect(self.app.activityIndicators["nextPage"].waitForExistence(timeout: 2)).to(beTrue())
        
        // Expect twice as many results to be loaded.
        let newLastCell = app.tables.element(boundBy: 0).cells.element(boundBy: 27)
        expect(newLastCell.waitForExistence(timeout: 2)).to(beTrue())
    }
    
    func testSelectingARepository() {
        // Tap the first cell.
        app.tables.element(boundBy: 0).cells.element(boundBy: 0).tap()
        
        // Expect the webview to be visible.
        expect(self.app.webViews.firstMatch.waitForExistence(timeout: 2)).to(beTrue())
    }

}

//
//  CompassUITests.swift
//  CompassUITests
//
//  Created by Matias Roldan on 06/06/2024.
//

import XCTest

final class CompassUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testHomeScreenElements() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(XCUIApplication().buttons["btnRequestData"].exists)
        XCTAssertTrue(XCUIApplication().cells["cell0"].exists)
        XCTAssertTrue(XCUIApplication().cells["cell1"].exists)
    }
    
    func testHomeScreenTapCellCharacters() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCUIApplication().buttons["btnRequestData"].tap()
        
        app.tables.cells["cell0"].staticTexts["Loaded"].tap()
    }
    
    func testHomeScreenTapCellWords() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCUIApplication().buttons["btnRequestData"].tap()
        
        app.tables.cells["cell1"].staticTexts["Loaded"].tap()
    }
}

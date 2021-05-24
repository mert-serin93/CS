//
//  ClearScoreUITests.swift
//  ClearScoreUITests
//
//  Created by Mert Serin on 2021-05-24.
//

import XCTest

class ClearScoreUITests: XCTestCase {

    var app: XCUIApplication!

    override class func setUp() {
        setenv("IS_UNIT_TESTING", "YES", 1)
    }

    func waitForElementToAppear(_ element: XCUIElement) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()

        app.launch()
    }


    func testCreditScoreAppear(){
        let circleView = app.children(matching: .any).containing(.any, identifier: "CircleView").firstMatch

        waitForElementToAppear(circleView)
    }

    func testCreditScoreLabelMediumColor() {
        let scoreLabel = app.children(matching: .any).containing(.any, identifier: "CreditScoreMedium").firstMatch

        waitForElementToAppear(scoreLabel)
    }

    func testCreditDetailScreen() -> XCUIElement{
        let detailButton = app.buttons.element(matching: .button, identifier: "CircleViewDetailButton").firstMatch

        detailButton.tap()

        waitForElementToAppear(app.staticTexts.element(matching: .staticText, identifier: "CreditDetailScoreLabel").firstMatch)

        return detailButton
    }

    func testCreditDetailAndBack() {
        let detailButton = testCreditDetailScreen()

        app.navigationBars.buttons.element(boundBy: 0).tap()

        waitForElementToAppear(detailButton)
    }
}

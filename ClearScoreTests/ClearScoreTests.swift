//
//  ClearScoreTests.swift
//  ClearScoreTests
//
//  Created by Mert Serin on 2021-05-24.
//

import Combine
import XCTest
@testable import ClearScore

class ClearScoreTests: XCTestCase {

    var storage = Set<AnyCancellable>()

    override class func setUp() {
        setenv("IS_UNIT_TESTING", "NO", 1)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSuccessCreditScore() {
        let expectationResult = XCTestExpectation(description: #function)
        let expectationResponse = XCTestExpectation(description: "response")
        Router.getCreditScore().sink { result in
            switch result {
            case .failure(let error): XCTFail(error.localizedDescription)
            case .finished: XCTAssert(true)
            }
            expectationResult.fulfill()
        } receiveValue: { response in
            expectationResponse.fulfill()
        }.store(in: &storage)

        wait(for: [expectationResult, expectationResponse], timeout: 5)

    }
}

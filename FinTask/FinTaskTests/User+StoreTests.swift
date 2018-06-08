//
//  User+StoreTests.swift
//  FinTaskTests
//
//  Created by Tomasz Pieczykolan on 08/06/2018.
//  Copyright © 2018 Tomasz Pieczykolan. All rights reserved.
//

import XCTest

@testable import FinTask

class UserStoreTests: XCTestCase {
    
    
    
    // MARK: - Tests
    
    func testSuccess() {
        let api = MockAPI(
            gitHubSuccess: [GitHubUser(login: "GitHub", avatar_url: "https://dummyimage.com/64x64/000000/ffffff")],
            gitHubError: nil,
            dailymotionSuccess: [DailymotionUser(username: "Dailymotion", avatar_360_url: "https://dummyimage.com/64x64/000000/ffffff")],
            dailymotionError: nil
        )
        
        let expectationGitHub = XCTestExpectation(description: "GitHub handler was not called")
        expectationGitHub.assertForOverFulfill = true
        let expectationDailymotion = XCTestExpectation(description: "Dailymotion handler was not called")
        expectationDailymotion.assertForOverFulfill = true
        
        User.fetchAll(from: api, newUsersHandler: { users in
            XCTAssertEqual(users.count, 1)
            switch users.first!.name {
            case "GitHub":
                expectationGitHub.fulfill()
            case "Dailymotion":
                expectationDailymotion.fulfill()
            default:
                XCTFail("Wrong user name")
            }
        }, errorHandler: { _ in
            XCTFail("This should not fail")
        })
        
        wait(for: [expectationGitHub, expectationDailymotion], timeout: 1.0)
    }
    
    func testOneFail() {
        let api = MockAPI(
            gitHubSuccess: nil,
            gitHubError: TestError.microsoft,
            dailymotionSuccess: [DailymotionUser(username: "Dailymotion", avatar_360_url: "https://dummyimage.com/64x64/000000/ffffff")],
            dailymotionError: nil
        )
        
        let expectationGitHub = XCTestExpectation(description: "GitHub error handler was not called")
        expectationGitHub.assertForOverFulfill = true
        let expectationDailymotion = XCTestExpectation(description: "Dailymotion handler was not called")
        expectationDailymotion.assertForOverFulfill = true
        
        User.fetchAll(from: api, newUsersHandler: { users in
            XCTAssertEqual(users.count, 1)
            switch users.first!.name {
            case "Dailymotion":
                expectationDailymotion.fulfill()
            default:
                XCTFail("Wrong user name")
            }
        }, errorHandler: { error in
            guard let testError = error as? TestError else { return XCTFail("Wrong type of error returned") }
            XCTAssertEqual(testError, TestError.microsoft, "Wrong error returned")
            expectationGitHub.fulfill()
        })
        
        wait(for: [expectationGitHub, expectationDailymotion], timeout: 1.0)
    }
    
    func testBothFail() {
        let api = MockAPI(
            gitHubSuccess: nil,
            gitHubError: TestError.microsoft,
            dailymotionSuccess: nil,
            dailymotionError: TestError.vimeo
        )
        
        let expectation = XCTestExpectation(description: "Error handlers were not called")
        expectation.expectedFulfillmentCount = 2
        expectation.assertForOverFulfill = true
        
        User.fetchAll(from: api, newUsersHandler: { users in
            XCTFail("This should not succeed")
        }, errorHandler: { error in
            guard error is TestError else { return XCTFail("Wrong type of error returned") }
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    
    // MARK: - Stubs / Utilities
    
    private class MockAPI: API {
        private let gitHubSuccess: [GitHubUser]?
        private let gitHubError: Swift.Error?
        private let dailymotionSuccess: [DailymotionUser]?
        private let dailymotionError: Swift.Error?
        
        init(
            gitHubSuccess: [GitHubUser]?,
            gitHubError: Swift.Error?,
            dailymotionSuccess: [DailymotionUser]?,
            dailymotionError: Swift.Error?
        ) {
            self.gitHubSuccess = gitHubSuccess
            self.gitHubError = gitHubError
            self.dailymotionSuccess = dailymotionSuccess
            self.dailymotionError = dailymotionError
            
            super.init(rest: .shared)
        }
        
        override func getGitHubUsers(successHandler: @escaping ([GitHubUser]) -> Void, errorHandler: @escaping (Swift.Error) -> Void) {
            if let success = gitHubSuccess {
                successHandler(success)
            } else if let error = gitHubError {
                errorHandler(error)
            }
        }
        
        override func getDailymotionUsers(successHandler: @escaping ([DailymotionUser]) -> Void, errorHandler: @escaping (Swift.Error) -> Void) {
            if let success = dailymotionSuccess {
                successHandler(success)
            } else if let error = dailymotionError {
                errorHandler(error)
            }
        }
    }
    
    private enum TestError: Error {
        case vimeo
        case microsoft
    }
}

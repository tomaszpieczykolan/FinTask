//
//  RestTests.swift
//  FinTaskTests
//
//  Created by Tomasz Pieczykolan on 06/06/2018.
//  Copyright © 2018 Tomasz Pieczykolan. All rights reserved.
//

import XCTest

@testable import FinTask

class RestTests: XCTestCase {
    
    
    
    // MARK: - Success tests
    
    func testData() {
        let url = URL(string: "https://www.example.com")!
        let testData = "Hello World! :)".data(using: .utf8)!
        let session = MockSession { (request, completionHandler) in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
            completionHandler(testData, response, nil)
        }
        let rest = Rest(session: session, decoder: JSONDecoder())
        rest.get(from: url, successHandler: { data in
            XCTAssertEqual(data, testData, "Data should not be modified by Rest")
        }, errorHandler: { error in
            XCTFail("This should not result in error")
        })
    }
    
    func testGenericGET() {
        let url = URL(string: "https://www.example.com")!
        let session = MockSession { (request, completionHandler) in
            let data = """
            {
                "testString": "test value"
            }
            """.data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
            completionHandler(data, response, nil)
        }
        let rest = Rest(session: session, decoder: JSONDecoder())
        rest.get(from: url, successHandler: { (model: TestModel) in
            XCTAssertEqual(model.testString, "test value")
        }, errorHandler: { error in
            XCTFail("This should not result in error")
        })
    }
    
    
    
    // MARK: - Error tests
    
    func testBadResponseError() {
        let url = URL(string: "https://www.example.com")!
        let session = MockSession { (request, completionHandler) in
            let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)
            completionHandler(nil, response, nil)
        }
        let rest = Rest(session: session, decoder: JSONDecoder())
        rest.get(from: url, successHandler: { data in
            XCTFail("This should not succeed")
        }, errorHandler: { error in
            guard case let Rest.Error.badResponse(statusCode: statusCode) = error else { return XCTFail("Wrong error returned") }
            XCTAssertEqual(statusCode, 404)
        })
    }
    
    func testMissingDataError() {
        let url = URL(string: "https://www.example.com")!
        let session = MockSession { (request, completionHandler) in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
            completionHandler(nil, response, nil)
        }
        let rest = Rest(session: session, decoder: JSONDecoder())
        rest.get(from: url, successHandler: { data in
            XCTFail("This should not succeed")
        }, errorHandler: { error in
            guard case Rest.Error.missingData = error else { return XCTFail("Wrong error returned") }
        })
    }
    
    func testCannotCastResponseError() {
        let url = URL(string: "https://www.example.com")!
        let session = MockSession { (request, completionHandler) in
            let response = URLResponse(url: request.url!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
            completionHandler(nil, response, nil)
        }
        let rest = Rest(session: session, decoder: JSONDecoder())
        rest.get(from: url, successHandler: { data in
            XCTFail("This should not succeed")
        }, errorHandler: { error in
            guard case Rest.Error.cannotCastResponse = error else { return XCTFail("Wrong error returned") }
        })
    }
    
    func testExternalError() {
        let url = URL(string: "https://www.example.com")!
        let session = MockSession { (request, completionHandler) in
            let data = Data()
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
            let error = CustomError.hello
            completionHandler(data, response, error)
        }
        let rest = Rest(session: session, decoder: JSONDecoder())
        rest.get(from: url, successHandler: { data in
            XCTFail("This should not succeed")
        }, errorHandler: { error in
            guard case CustomError.hello = error else { return XCTFail("Wrong error returned") }
        })
    }
    
    func testGenericGetBadJSON() {
        let url = URL(string: "https://www.example.com")!
        let session = MockSession { (request, completionHandler) in
            let data = """
            [
                testString":: "this JSON is drunk"
            }
            """.data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
            completionHandler(data, response, nil)
        }
        let rest = Rest(session: session, decoder: JSONDecoder())
        rest.get(from: url, successHandler: { (model: TestModel) in
            XCTFail("This should not succeed")
        }, errorHandler: { error in
            XCTAssert(error is DecodingError)
        })
    }
    
    
    
    // MARK: - Stubs / Utilities
    
    private class MockSession: URLSession {
        typealias CompletionHandler = (_ request: URLRequest, _ completionHandler: (Data?, URLResponse?, Error?) -> Swift.Void) -> Void
        private var sessionCompletionHandler: CompletionHandler
        init(completionHandler: @escaping CompletionHandler) {
            self.sessionCompletionHandler = completionHandler
            super.init()
        }
        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
            return MockTask(resumeHandler: {
                self.sessionCompletionHandler(request, completionHandler)
            })
        }
    }
    
    private class MockTask: URLSessionDataTask {
        private var resumeHandler: () -> Void
        init(resumeHandler: @escaping () -> Void) {
            self.resumeHandler = resumeHandler
            super.init()
        }
        override func resume() {
            self.resumeHandler()
        }
    }
    
    private enum CustomError: Error {
        case hello
        case world
    }
    
    private struct TestModel: Decodable {
        let testString: String
    }
}

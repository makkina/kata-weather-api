//
//  NetworkClientTests.swift
//  WeatherAppTests
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import XCTest
@testable import WeatherApp

class NetworkClientTests: XCTestCase {
    
    private var error: Error!
    private var urlSessionMock: URLSessionMock!
    
    override func setUp() {
        super.setUp()
        urlSessionMock = URLSessionMock()
    }
    
    override func tearDown() {
        error = nil
        urlSessionMock = nil
        super.tearDown()
    }
    
    // MARK: - Mock Tests
    
    func testURLSessionMethodIsGET() {
        // given
        let client = NetworkClient(urlSession: urlSessionMock)
        // when
        client.get(urlString: "Antwerp") { (_ data, _ error) in }
        // then
        XCTAssertEqual(urlSessionMock.requestReceived?.httpMethod, "GET")
    }
    
    func testURLSessionReceivesUrlData() {
        // given
        let baseUrl = Constants.baseURL
        let token = Secrets.openWeatherTestToken
        let city = "Antwerp"
        let urlString = "\(baseUrl)&appid=\(token)&q=\(city)"
        let client = NetworkClient(urlSession: urlSessionMock)
        
        // when
        client.get(urlString: urlString) { (_ result, _ error) in }
        
        // then
        XCTAssertEqual(urlSessionMock.requestReceived?.url?.absoluteString, urlString)
    }
 
    func testDataTaskCallsResume() {
        // given
        let task = URLSessionDataTaskMock()
        urlSessionMock.mockURLSessionDataTask = task
        let client = NetworkClient(urlSession: urlSessionMock)
        
        // when
        client.get(urlString: "Antwerp") { (_ data, _ error) in }
        
        // then
        XCTAssertTrue(task.hasResumeBeenCalled)
    }
    
    func testCanInvokeCompletionBlock() {
        // given
        let client = NetworkClient(urlSession: urlSessionMock)
        let queryExpectation = XCTestExpectation(description: "Completion handler invokes")
         queryExpectation.expectedFulfillmentCount = 1
        
        // when
        client.get(urlString: "Antwerp") { ( _ responseData, _ responseError ) in
            queryExpectation.fulfill()
        }
        
        // then
        wait(for: [queryExpectation], timeout: 5)
        XCTAssertTrue(true)
    }
    
    func testCanInvokeCompletionBlockWithResponse() {
        // given
        urlSessionMock.mockData = "{json:data}".data(using: .utf8)
        let client = NetworkClient(urlSession: urlSessionMock)
        var data: Data?
        let queryExpectation = XCTestExpectation(description: "Completion handler invokes")
        queryExpectation.expectedFulfillmentCount = 1
        
        // when
        client.get(urlString: "Antwerp") { ( responseData, _ responseError ) in
            if responseData != nil {
                data = responseData
                queryExpectation.fulfill()
            }
        }
        
        // then
        wait(for: [queryExpectation], timeout: 5)
        XCTAssertNotNil(data)
    }
    
    func testCanInvokeCompletionBlockWithError() {
        // given
        urlSessionMock.mockError = NSError.init(domain: "Error", code: 405, userInfo: nil)
        let client = NetworkClient(urlSession: urlSessionMock)
        var error: Error?
        let queryExpectation = XCTestExpectation(description: "Completion handler invokes")
        queryExpectation.expectedFulfillmentCount = 1
        
        // when
        client.get(urlString: "Antwerp") { ( _ responseData, responseError ) in
            if let safeError = responseError {
                error = safeError
                queryExpectation.fulfill()
            }
        }
        
        // then
        wait(for: [queryExpectation], timeout: 5)
        XCTAssertNotNil(error)
    }
    
    // MARK: - Network Call
    
    func testCanConnectWithWeb() {
        // given
        let networkClient = NetworkClient()
        let urlString = "https://google.be"
        let queryExpectation = XCTestExpectation(description: "Completion handler invoked with success")
        queryExpectation.expectedFulfillmentCount = 1
        
        // when
        networkClient.get(urlString: urlString) { (_ data, errorResponse) in
            if errorResponse != nil {
                self.error = errorResponse
            }
            queryExpectation.fulfill()
        }
        
        // then
        wait(for: [queryExpectation], timeout: 5)
        XCTAssertNil(self.error)
    }
    
    func testCompletionHandlerExecutesOnTheMainThrea() {
        // given
        let networkClient = NetworkClient()
        let urlString = "https://google.be"
        let queryExpectation = XCTestExpectation(description: "Completion handler invoked with success")
        var isMainThread = false
        
        // when
        networkClient.get(urlString: urlString) { (_ data, _ error) in
            isMainThread = Thread.isMainThread
            queryExpectation.fulfill()
        }
        
        // then
        wait(for: [queryExpectation], timeout: 5)
        XCTAssertTrue(isMainThread)
    }
}

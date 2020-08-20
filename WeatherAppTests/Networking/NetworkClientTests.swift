//
//  NetworkClientTests.swift
//  WeatherAppTests
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import XCTest
@testable import WeatherApp

// MARK: - Tests

class NetworkClientTests: XCTestCase {
    
    var error: Error!
    var urlSessionMock: URLSessionMock!
    
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
        let baseUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric"
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
    
    func testCanInvoteCompletionBlockWithResponse() {
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
    
    func testCanInvoteCompletionBlockWithError() {
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
}
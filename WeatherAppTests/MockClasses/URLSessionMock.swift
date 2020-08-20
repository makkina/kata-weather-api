//
//  URLSessionMock.swift
//  WeatherAppTests
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import Foundation
@testable import WeatherApp

class URLSessionMock: URLSessionProtocol {

    private(set) var requestReceived: URLRequest?
    var mockData: Data?
    var mockURLResponse: URLResponse?
    var mockError: Error?
    var mockURLSessionDataTask: URLSessionDataTaskProtocol?
    
    func dataTask(with request: URLRequest, completion: @escaping URLSessionDataTaskCompletion) -> URLSessionDataTaskProtocol {
        
        requestReceived = request
        completion(mockData, mockURLResponse, mockError)
        
        return mockURLSessionDataTask ?? URLSessionDataTaskMock()
    }
}

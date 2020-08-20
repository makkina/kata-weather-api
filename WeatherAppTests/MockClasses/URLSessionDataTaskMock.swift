//
//  URLSessionDataTaskMock.swift
//  WeatherAppTests
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import Foundation
@testable import WeatherApp

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    
    private(set) var hasResumeBeenCalled = false
    
    func resume() {
        hasResumeBeenCalled = true
    }
}

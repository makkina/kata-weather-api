//
//  NetworkClientMock.swift
//  WeatherAppTests
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import Foundation
@testable import WeatherApp

class NetworkClientMock: NetworkClientProtocol {

    private(set) var urlStringReceived: String?
    var mockResult: Data?
    var mockError: Error?
    
    func get(urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        urlStringReceived = urlString
        completion(mockResult, mockError)
    }
}

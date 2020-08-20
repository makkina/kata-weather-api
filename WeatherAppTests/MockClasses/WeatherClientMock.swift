//
//  WeatherClientMock.swift
//  WeatherAppTests
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import Foundation
@testable import WeatherApp

class WeatherClientMock: WeatherClientProtocol {
    
    private(set) var urlStringReceived: String?
    var mockResult: WeatherModel?
    var mockError: Error?
    
    func getWeather(with urlString: String, completion: @escaping ((WeatherModel?, Error?) -> Void)) {
        
        urlStringReceived = urlString
        completion(mockResult, mockError)
    }
}

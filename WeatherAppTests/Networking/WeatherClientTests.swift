//
//  WeatherClientTests.swift
//  WeatherAppTests
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import XCTest
@testable import WeatherApp

// MARK: - Tests

class WeatherClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCanReceiveUrlString() {
        // given
        let weatherClient = WeatherClientMock()
        // when
        weatherClient.getWeather(with: "StadUrl") { (_ weatherModel, _ error) in }
        // then
        XCTAssertEqual(weatherClient.urlStringReceived, "StadUrl")
    }
    
    func testCanCallNetworkClientWithUrlString() {
        // given
        let networkClient = NetworkClientMock()
        let weatherClient = WeatherClient(networkClient: networkClient)
        // when
        weatherClient.getWeather(with: "StadUrl") { (_ weatherModel, _ error) in }
        // then
        XCTAssertEqual(networkClient.urlStringReceived, "StadUrl")
    }
    
    func testCanInvokeCompletionHandlerWithError() {
        // given
        let networkClient = NetworkClientMock()
        networkClient.mockError = NSError.init(
            domain: "Error",
            code: 405,
            userInfo: nil
        )
        let weatherClient = WeatherClient(networkClient: networkClient)
        var error: Error?
        
        // when
        weatherClient.getWeather(with: "StadUrl") { (_ responseWeatherModel, responseError) in
            if let safeError = responseError {
                error = safeError
            }
        }
        
        // then
        XCTAssertNotNil(error)
    }

    func testCanInvokeCompletionHandlerWithNil() {
        // given
        let networkClient = NetworkClientMock()
        networkClient.mockResult = nil
        let weatherClient = WeatherClient(networkClient: networkClient)
        var weatherModel: WeatherModel? = WeatherModel(
            conditionId: 200,
            cityName: "Brussels",
            temperature: 20
        )
        
        // when
        weatherClient.getWeather(with: "Brussels") { ( responseWeatherModel, _ responseError) in
            weatherModel = responseWeatherModel
        }
        
        // then
        XCTAssertNil(weatherModel)
    }

    func testCanInvokeCompletionHandlerWithWeatherModel() {
        // swiftlint:disable force_try
        let networkClient = NetworkClientMock()
        let encoder = JSONEncoder()
        let weatherModelDto = WeatherModelDTO(
            name: "Brussels",
            main: MainDTO(temp: 20),
            weather: [WeatherDTO(id: 200)]
        )
        networkClient.mockResult = try! encoder.encode(weatherModelDto)
        let weatherClient = WeatherClient(networkClient: networkClient)
        var weatherModel: WeatherModel?
        // swiftlint:enable force_try
        
        // when
        weatherClient.getWeather(with: "Brussels") { ( responseWeatherModel, _ responseError) in
            weatherModel = responseWeatherModel
        }
        
        // then
        XCTAssertEqual(weatherModel?.cityName, "Brussels")
    }
    
    // MARK: - Network Call
    
    func testCanReturnWeatherModelFromNetwork() {
        // given
        let networkClient = NetworkClient()
        let weatherClient = WeatherClient(networkClient: networkClient)
        var weatherModel: WeatherModel?
        let queryExpectation = XCTestExpectation(description: "Completion handler invoked with success")
        queryExpectation.expectedFulfillmentCount = 1
        let baseUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric"
        let token = Secrets.openWeatherTestToken
        let city = "Brussels"
        let urlString = "\(baseUrl)&appid=\(token)&q=\(city)"
        
        // when
        weatherClient.getWeather(with: urlString) { ( responseWeatherModel, _ responseError) in
            if let safeWeatherModel = responseWeatherModel {
                weatherModel = safeWeatherModel
                queryExpectation.fulfill()
            }
        }
        
        // then
        wait(for: [queryExpectation], timeout: 3)
        XCTAssertEqual(weatherModel?.cityName, "Brussels")
    }
}

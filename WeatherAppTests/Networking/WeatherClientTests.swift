//
//  WeatherClientTests.swift
//  WeatherAppTests
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherClientTests: XCTestCase {
    
    private var networkClient: NetworkClientMock!
    
    override func setUp() {
        super.setUp()
        networkClient = NetworkClientMock()
    }
    
    override func tearDown() {
        networkClient = nil
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
        let weatherClient = WeatherClient(networkClient: networkClient)
        // when
        weatherClient.getWeather(with: "StadUrl") { (_ weatherModel, _ error) in }
        // then
        XCTAssertEqual(networkClient.urlStringReceived, "StadUrl")
    }
    
    func testCanInvokeCompletionHandlerWithError() {
        // given
        networkClient.mockError = Mock.error()
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
        networkClient.mockResult = nil
        let weatherClient = WeatherClient(networkClient: networkClient)
        var weatherModel: WeatherModel? = Mock.weatherModel()
        
        // when
        weatherClient.getWeather(with: "Brussels") { ( responseWeatherModel, _ responseError) in
            weatherModel = responseWeatherModel
        }
        
        // then
        XCTAssertNil(weatherModel)
    }

    func testCanInvokeCompletionHandlerWithWeatherModel() {
        // swiftlint:disable force_try
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

    func testWillInitiateWithStateNotLoading() {
        let weatherClient = WeatherClient(networkClient: NetworkClient())
        XCTAssertEqual(weatherClient.state, .notLoading)
    }
    
    func testWillAlterStateToLoadingWhenFetchingWeather() {
        // given
        let weatherClient = WeatherClient(networkClient: NetworkClient())
        // when
        weatherClient.getWeather(with: "Antwerp") { (_ weatherModel, _ error) in }
        // then
        XCTAssertEqual(weatherClient.state, .loading)
    }
    
    func testWillAlterStateToNotLoadingAfterCompletion() {
        // given
        let weatherClient = WeatherClient(networkClient: NetworkClient())
        let queryExpectation = XCTestExpectation(description: "completionHandler")
        // when
        weatherClient.getWeather(with: "Antwerp") { (_ weatherModel, _ error) in
            queryExpectation.fulfill()
        }
        // then
        wait(for: [queryExpectation], timeout: 3)
        XCTAssertEqual(weatherClient.state, .notLoading)
    }
    
    // MARK: - Network Call
    /**
     The following is an integration test. Ideally we could move it into a seperate target.
     This call is different from the previous as this actually hits the network.
     */
    func testCanReturnWeatherModelFromNetwork() {
        // given
        let networkClient = NetworkClient()
        let weatherClient = WeatherClient(networkClient: networkClient)
        var weatherModel: WeatherModel?
        let queryExpectation = XCTestExpectation(description: "Completion handler invoked with success")
        queryExpectation.expectedFulfillmentCount = 1
        let baseUrl = Constants.baseURL
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

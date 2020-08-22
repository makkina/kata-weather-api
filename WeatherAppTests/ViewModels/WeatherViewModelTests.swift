//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Makkina on 21/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {
    
    private var queryExpectation: XCTestExpectation!
    private var viewModel: WeatherViewModel!
    private var weatherClientMock: WeatherClientMock!
    
    override func setUp() {
        super.setUp()
        viewModel = WeatherViewModel(
            weatherClient: WeatherClient(
                networkClient: NetworkClient()
            )
        )
        weatherClientMock = WeatherClientMock()
    }
    
    override func tearDown() {
        viewModel = nil
        weatherClientMock = nil
        super.tearDown()
    }
    
    func testCanFetchWeatherModelUsingNetworkClient() {
        // given
        weatherClientMock.mockResult = WeatherModelFactory.weatherModel(nil, "Antwerp", nil)

        // when
        viewModel = WeatherViewModel(weatherClient: weatherClientMock)
        viewModel.fetchWeather(city: "Antwerp")
        
        // then
        XCTAssertEqual(viewModel.weatherModel?.cityName, "Antwerp")
    }
    
    func testCanReturnEmptyWeatherModelUsingNetworkClient() {
         // given
        weatherClientMock.mockError = WeatherModelFactory.error()
        
        // when
        viewModel = WeatherViewModel(weatherClient: weatherClientMock)
        viewModel.fetchWeather(city: "Antwerp")

        // then
        XCTAssertNil(viewModel.weatherModel)
    }
    
    func testWillOnlyFetchWeatherForValidCities() {
        // given
        viewModel = WeatherViewModel(weatherClient: WeatherClient(networkClient: NetworkClient()))
        viewModel.delegate = self
        queryExpectation = XCTestExpectation(description: "doesNotFetchWeatherModel")
        queryExpectation.expectedFulfillmentCount = 2
        
        // when
        viewModel.fetchWeather(city: "Paris")
            
        // then
        wait(for: [queryExpectation], timeout: 3)
        XCTAssertNil(viewModel.weatherModel)
    }
    
    func testWeatherLabelIsHidden() {
        // given
        weatherClientMock.mockState = .loading
        // when
        viewModel = WeatherViewModel(weatherClient: weatherClientMock)
        // then
        XCTAssertEqual(viewModel.weatherLabelIsHidden, true)
    }
    
    func testWeatherLabelIsNotHidden() {
        // given
        weatherClientMock.mockState = .notLoading
        // when
        viewModel = WeatherViewModel(weatherClient: weatherClientMock)
        // then
        XCTAssertEqual(viewModel.weatherLabelIsHidden, false)
    }
    
    func testWeatherLabelDisplaysCelciusSymbolWhenTemperatureIsSet() {
        // given
        let cityName = "Antwerp"
        weatherClientMock.mockResult = WeatherModelFactory.weatherModel(200, cityName, 23)
        
        // when
        viewModel = WeatherViewModel(weatherClient: weatherClientMock)
        viewModel.fetchWeather(city: cityName)
        
        // then
        XCTAssertEqual(viewModel.weatherLabelText, "23.0 °C")
    }
    
    func testWeatherLabelDisplayWhenTemperatureIsNoSet() {
        // when
        viewModel = WeatherViewModel(weatherClient: WeatherClientMock())
        
        // then
        XCTAssertEqual(viewModel.weatherLabelText, "°C")
    }
    
    // MARK: - Test Weather Condition Name
    
    func testConditionName2xx() {
        // given
        let conditionId = Int.random(in: 200...232)
        // when
        weatherClientMock.mockResult = WeatherModelFactory.weatherModel(conditionId)
        viewModel = WeatherViewModel(weatherClient: weatherClientMock)
        viewModel.fetchWeather(city: "Brussels")
        // then
        XCTAssertEqual(viewModel.weatherConditionName, "cloud.bolt")
    }
    
    func testConditionName3xx() {
        // given
        let conditionId = Int.random(in: 300...321)
        // when
        weatherClientMock.mockResult = WeatherModelFactory.weatherModel(conditionId)
        viewModel = WeatherViewModel(weatherClient: weatherClientMock)
        viewModel.fetchWeather(city: "Brussels")
        // then
        XCTAssertEqual(viewModel.weatherConditionName, "cloud.drizzle")
    }
    
    func testConditionName5xx() {
        // given
        let conditionId = Int.random(in: 500...521)
        // when
        weatherClientMock.mockResult = WeatherModelFactory.weatherModel(conditionId)
        viewModel = WeatherViewModel(weatherClient: weatherClientMock)
        viewModel.fetchWeather(city: "Brussels")
        // then
        XCTAssertEqual(viewModel.weatherConditionName, "cloud.rain")
    }
    
    func testConditionName6xx() {
        // given
        let conditionId = Int.random(in: 600...622)
        // when
        weatherClientMock.mockResult = WeatherModelFactory.weatherModel(conditionId)
        viewModel = WeatherViewModel(weatherClient: weatherClientMock)
        viewModel.fetchWeather(city: "Brussels")
        // then
        XCTAssertEqual(viewModel.weatherConditionName, "cloud.snow")
    }
    
    func testConditionName7xx() {
        // given
        let conditionId = Int.random(in: 701...781)
        // when
        weatherClientMock.mockResult = WeatherModelFactory.weatherModel(conditionId)
        viewModel = WeatherViewModel(weatherClient: weatherClientMock)
        viewModel.fetchWeather(city: "Brussels")
        // then
        XCTAssertEqual(viewModel.weatherConditionName, "cloud.fog")
    }
    
    func testConditionName800() {
        // given
        let conditionId = 800
        // when
        weatherClientMock.mockResult = WeatherModelFactory.weatherModel(conditionId)
        viewModel = WeatherViewModel(weatherClient: weatherClientMock)
        viewModel.fetchWeather(city: "Brussels")
        // then
        XCTAssertEqual(viewModel.weatherConditionName, "sun.max")
    }
    
    func testConditionName8xx() {
        // given
        let conditionId = Int.random(in: 801...804)
        // when
        weatherClientMock.mockResult = WeatherModelFactory.weatherModel(conditionId)
        viewModel = WeatherViewModel(weatherClient: weatherClientMock)
        viewModel.fetchWeather(city: "Brussels")
        // then
        XCTAssertEqual(viewModel.weatherConditionName, "cloud.bolt")
    }
    
    func testConditionNameDefault() {
        // given
        let conditionId = Int.random(in: 804...1000)
        // when
        weatherClientMock.mockResult = WeatherModelFactory.weatherModel(conditionId)
        viewModel = WeatherViewModel(weatherClient: weatherClientMock)
        viewModel.fetchWeather(city: "Brussels")
        // then
        XCTAssertEqual(viewModel.weatherConditionName, "cloud")
    }
    
    func testFetchingInvalidCityClearsOutWeatherModel() {
        // given
        weatherClientMock.mockResult = WeatherModelFactory.weatherModel()
        // when
        viewModel = WeatherViewModel(weatherClient: weatherClientMock)
        viewModel.fetchWeather(city: "Paris")
        // then
        XCTAssertNil(viewModel.weatherModel)
    }
    
    // MARK: - Network Call
    /**
     The following is an integration test. Ideally we could move it into a seperate target.
     This call is different from the previous as this actually hits the network.
     */
    func testCanFillWeatherModel() {
        // given
        let cityName = "Brussels"
        viewModel.delegate = self
        queryExpectation = XCTestExpectation(description: "fillUpWeatherModel")
        queryExpectation.expectedFulfillmentCount = 2
        
        // when
        viewModel.fetchWeather(city: cityName)
        
        // then
        wait(for: [queryExpectation], timeout: 3)
        XCTAssertEqual(viewModel.weatherModel?.cityName, cityName)
    }
}

// MARK: - WeatherViewModelDelegate

extension WeatherViewModelTests: WeatherViewModelDelegate {
    
    func willLoadData() {
        queryExpectation.fulfill()
    }
    
    func didLoadData() {
        queryExpectation.fulfill()
    }
}

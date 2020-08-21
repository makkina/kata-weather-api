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
    
    var queryExpectation: XCTestExpectation!
    var viewModel: WeatherViewModel!
    var weatherClientMock: WeatherClientMock!
    
    override func setUp() {
        super.setUp()
        viewModel = WeatherViewModel(
            weatherModel: nil,
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
        let cityName = "Antwerp"
        let weatherModelMock = Mock.weatherModel(nil, cityName, nil)
        weatherClientMock.mockResult = weatherModelMock
        
        // when
        let viewModel = WeatherViewModel(
            weatherModel: nil,
            weatherClient: weatherClientMock
        )
        viewModel.fetchWeather(city: cityName)
        
        // then
        XCTAssertEqual(viewModel.weatherModel?.cityName, "Antwerp")
    }
    
    func testCanReturnEmptyWeatherModelUsingNetworkClient() {
         // given
        weatherClientMock.mockError = Mock.error()
        
        // when
        let viewModel = WeatherViewModel(
            weatherModel: nil,
            weatherClient: weatherClientMock
        )
        viewModel.fetchWeather(city: "Antwerp")

        // then
        XCTAssertNil(viewModel.weatherModel)
    }
    
    func testWillOnlyFetchWeatherForValidCities() {
        // given
        let _viewModel = WeatherViewModel(
            weatherModel: nil,
            weatherClient: WeatherClient(networkClient: NetworkClient())
        )
        _viewModel.delegate = self
        queryExpectation = XCTestExpectation(description: "doesNotFetchWeatherModel")
        queryExpectation.expectedFulfillmentCount = 2
        
        // when
        _viewModel.fetchWeather(city: "Paris")
            
        // then
        wait(for: [queryExpectation], timeout: 3)
        XCTAssertNil(_viewModel.weatherModel)
    }
    
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
    
    func testWeatherLabelIsHidden() {
        // given
        let weatherClientMock = WeatherClientMock()
        weatherClientMock.mockState = .loading
        
        // when
        let viewModel = WeatherViewModel(weatherModel: nil, weatherClient: weatherClientMock)
        
        // then
        XCTAssertEqual(viewModel.weatherLabelIsHidden, true)
    }
    
    func testWeatherLabelIsNotHidden() {
        // given
        let weatherClientMock = WeatherClientMock()
        weatherClientMock.mockState = .notLoading
        
        // when
        let viewModel = WeatherViewModel(weatherModel: nil, weatherClient: weatherClientMock)
        
        // then
        XCTAssertEqual(viewModel.weatherLabelIsHidden, false)
    }
    
    func testWeatherLabelDisplaysCelciusSymbolWhenTemperatureIsSet() {
        // given
        let cityName = "Antwerp"
        let weatherClientMock = WeatherClientMock()
        let weatherModelMock = WeatherModel(conditionId: 200, cityName: cityName, temperature: 23)
        
        // when
        let viewModel = WeatherViewModel(weatherModel: weatherModelMock, weatherClient: weatherClientMock)
        
        // then
        XCTAssertEqual(viewModel.weatherLabelText, "23.0 °C")
    }
    
    func testWeatherLabelDisplayWhenTemperatureIsNoSet() {
        // when
        let viewModel = WeatherViewModel(
            weatherModel: nil,
            weatherClient: WeatherClientMock()
        )
        
        // then
        XCTAssertEqual(viewModel.weatherLabelText, "°C")
    }
    
    // MARK: - Test Weather Condition Name
    
    func testConditionName2xx() {
        // given
        let conditionId = Int.random(in: 200...232)
        // when
        let weatherModel = WeatherModel(conditionId: conditionId, cityName: "Antwerp", temperature: 20)
        let viewModel = WeatherViewModel(weatherModel: weatherModel, weatherClient: WeatherClientMock())
        // then
        XCTAssertEqual(viewModel.weatherConditionName, "cloud.bolt")
    }
    
    func testConditionName3xx() {
        // given
        let conditionId = Int.random(in: 300...321)
        // when
        let weatherModel = WeatherModel(conditionId: conditionId, cityName: "Antwerp", temperature: 20)
        let viewModel = WeatherViewModel(weatherModel: weatherModel, weatherClient: WeatherClientMock())
        // then
        XCTAssertEqual(viewModel.weatherConditionName, "cloud.drizzle")
    }
    
    func testConditionName5xx() {
        // given
        let conditionId = Int.random(in: 500...521)
        // when
        let weatherModel = WeatherModel(conditionId: conditionId, cityName: "Antwerp", temperature: 20)
        let viewModel = WeatherViewModel(weatherModel: weatherModel, weatherClient: WeatherClientMock())
        // then
        XCTAssertEqual(viewModel.weatherConditionName, "cloud.rain")
    }
    
    func testConditionName6xx() {
        // given
        let conditionId = Int.random(in: 600...622)
        // when
        let weatherModel = WeatherModel(conditionId: conditionId, cityName: "Antwerp", temperature: 20)
        let viewModel = WeatherViewModel(weatherModel: weatherModel, weatherClient: WeatherClientMock())
        // then
        XCTAssertEqual(viewModel.weatherConditionName, "cloud.snow")
    }
    
    func testConditionName7xx() {
        // given
        let conditionId = Int.random(in: 701...781)
        // when
        let weatherModel = WeatherModel(conditionId: conditionId, cityName: "Antwerp", temperature: 20)
        let viewModel = WeatherViewModel(weatherModel: weatherModel, weatherClient: WeatherClientMock())
        // then
        XCTAssertEqual(viewModel.weatherConditionName, "cloud.fog")
    }
    
    func testConditionName800() {
        // given
        let conditionId = 800
        // when
        let weatherModel = WeatherModel(conditionId: conditionId, cityName: "Antwerp", temperature: 20)
        let viewModel = WeatherViewModel(weatherModel: weatherModel, weatherClient: WeatherClientMock())
        // then
        XCTAssertEqual(viewModel.weatherConditionName, "sun.max")
    }
    
    func testConditionName8xx() {
        // given
        let conditionId = Int.random(in: 801...804)
        // when
        let weatherModel = WeatherModel(conditionId: conditionId, cityName: "Antwerp", temperature: 20)
        let viewModel = WeatherViewModel(weatherModel: weatherModel, weatherClient: WeatherClientMock())
        // then
        XCTAssertEqual(viewModel.weatherConditionName, "cloud.bolt")
    }
    
    func testConditionNameDefault() {
        // given
        let conditionId = Int.random(in: 804...1000)
        // when
        let weatherModel = WeatherModel(conditionId: conditionId, cityName: "Antwerp", temperature: 20)
        let viewModel = WeatherViewModel(weatherModel: weatherModel, weatherClient: WeatherClientMock())
        // then
        XCTAssertEqual(viewModel.weatherConditionName, "cloud")
    }
    
    func testFetchingInvalidCityClearsOutWeatherModel() {
        // given
        let weatherModel = WeatherModel(conditionId: 200, cityName: "Antwerp", temperature: 20)
        let viewModel = WeatherViewModel(weatherModel: weatherModel, weatherClient: WeatherClientMock())
        
        // when
        viewModel.fetchWeather(city: "Paris")
        // then
        XCTAssertNil(viewModel.weatherModel)
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

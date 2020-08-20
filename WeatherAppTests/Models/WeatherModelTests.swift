//
//  WeatherModelTests.swift
//  WeatherAppTests
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherModelTests: XCTestCase {

    func testCityNameIsInitialized() {
        let cityName = "Antwerp"
        let weatherModel = WeatherModel(conditionId: 200, cityName: cityName, temperature: 10)
        XCTAssertEqual(weatherModel.cityName, "Antwerp")
    }

    func testTemperatureIsInitialized() {
        let temperature = 20.0
        let weatherModel = WeatherModel(conditionId: 200, cityName: "Antwerp", temperature: temperature)
        XCTAssertEqual(weatherModel.temperature, temperature)
    }

    func testTemperatureCelciusIsInitialized() {
        let conditionId = 500
        let weatherModel = WeatherModel(conditionId: conditionId, cityName: "Antwerp", temperature: 10)
        XCTAssertEqual(weatherModel.conditionId, conditionId)
    }
}

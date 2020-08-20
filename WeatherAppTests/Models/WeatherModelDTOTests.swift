//
//  WeatherModelDTOTests.swift
//  WeatherAppTests
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherModelDTOTests: XCTestCase {
    
    func testWeatherModelDtoMapperForTemperature() {
        // given
        let weatherModelDto = WeatherModelDTO(
            name: "Antwerp",
            main: MainDTO(temp: 20),
            weather: [WeatherDTO(id: 200)]
        )
        // when
        let weatherModel = WeatherModelDTOMapper.map(weatherModelDto)
        // then
        XCTAssertEqual(weatherModelDto.main.temp, weatherModel.temperature)
    }
    
    func testWeatherModelDtoMapperForCityName() {
        // given
        let weatherModelDto = WeatherModelDTO(
            name: "Antwerp",
            main: MainDTO(temp: 20),
            weather: [WeatherDTO(id: 200)]
        )
        // when
        let weatherModel = WeatherModelDTOMapper.map(weatherModelDto)
        // then
        XCTAssertEqual(weatherModelDto.name, weatherModel.cityName)
    }
    
    func testWeatherModelDtoMapperForWeatherConditionId() {
        // given
        let weatherModelDto = WeatherModelDTO(
            name: "Antwerp",
            main: MainDTO(temp: 20),
            weather: [WeatherDTO(id: 200)]
        )
        // when
        let weatherModel = WeatherModelDTOMapper.map(weatherModelDto)
        // then
        XCTAssertEqual(weatherModelDto.weather[0].id, weatherModel.conditionId)
    }
}

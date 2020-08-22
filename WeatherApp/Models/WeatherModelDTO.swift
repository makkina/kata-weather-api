//
//  WeatherModelDTO.swift
//  WeatherApp
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import Foundation

struct WeatherModelDTO: Codable {
    let name: String
    let main: MainDTO
    let weather: [WeatherDTO]
}

struct MainDTO: Codable {
    let temp: Double
}

struct WeatherDTO: Codable {
    let id: Int
}

/**
 Ideally we would add a safeguard and return an optional here, as `dto.weather` could theoretically be empty.
 However we know, openWeatherApi will always return at minimum 1 single weatherObject.
 */
struct WeatherModelDTOMapper {
    static func map(_ dto: WeatherModelDTO) -> WeatherModel {
        return WeatherModel(
            conditionId: dto.weather[0].id,
            cityName: dto.name,
            temperature: dto.main.temp
        )
    }
}

//
//  WeatherModelDTO.swift
//  WeatherApp
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import Foundation

struct WeatherModelDTO: Decodable {
    let name: String
    let main: MainDTO
    let weather: [WeatherDTO]
}

struct MainDTO: Decodable {
    let temp: Double
}

struct WeatherDTO: Decodable {
    let id: Int
}

struct WeatherModelDTOMapper {
    static func map(_ dto: WeatherModelDTO) -> WeatherModel {
        return WeatherModel(
            conditionId: dto.weather[0].id,
            cityName: dto.name,
            temperature: dto.main.temp
        )
    }
}

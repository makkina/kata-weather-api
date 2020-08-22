//
//  Mock.swift
//  WeatherAppTests
//
//  Created by Makkina on 21/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import Foundation
@testable import WeatherApp

struct WeatherModelFactory {
    static func error () -> Error {
        return NSError.init(domain: "Error", code: 304, userInfo: nil)
    }
    
    static func weatherModel (
        _ conditionId: Int? = nil,
        _ cityName: String? = nil,
        _ temperature: Double? = nil
    ) -> WeatherModel {
        
        return WeatherModel(
            conditionId: conditionId ?? 200,
            cityName: cityName ?? "Antwerp",
            temperature: temperature ?? 20.0
        )
    }
    
    static func weatherModelDTO (
        _ cityName: String? = nil,
        _ temperature: Double? = nil,
        _ conditionId: Int? = nil
    ) -> WeatherModelDTO {
        
        return WeatherModelDTO(
            name: cityName ?? "Antwerp",
            main: MainDTO(temp: temperature ?? 20),
            weather: [WeatherDTO(id: conditionId ?? 200)]
        )
    }
}

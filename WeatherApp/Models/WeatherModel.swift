//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    init(conditionId: Int, cityName: String, temperature: Double) {
        self.conditionId = conditionId
        self.cityName = cityName
        self.temperature = temperature
    }
}

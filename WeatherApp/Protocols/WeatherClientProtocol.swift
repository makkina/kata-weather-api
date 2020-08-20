//
//  WeatherClientProtocol.swift
//  WeatherApp
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import Foundation

protocol WeatherClientProtocol {
    
    func getWeather(
        with urlString: String,
        completion: @escaping ((WeatherModel?, Error?) -> Void)
    )
}

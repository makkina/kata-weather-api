//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Makkina on 21/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import Foundation

protocol WeatherViewModelDelegate: AnyObject {
    func willLoadData()
    func didLoadData()
}

class WeatherViewModel {
    
    weak var delegate: WeatherViewModelDelegate?
    var weatherModel: WeatherModel?
    var weatherClient: WeatherClientProtocol
    private let validCities: [String]
    
    // MARK: - Init
    
    init(weatherModel: WeatherModel?, weatherClient: WeatherClientProtocol) {
        self.weatherModel = weatherModel
        self.weatherClient = weatherClient
        self.validCities = ["Antwerp", "Brussels", "Ghent"]
    }
    
    func fetchWeather(city: String) {
        delegate?.willLoadData()
     
        // Check for valid city
        guard validCities.contains(city) else {
            self.delegate?.didLoadData()
            return
        }
        
        // Create Url
        let baseUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric"
        let token = Secrets.openWeatherTestToken
        let urlString = "\(baseUrl)&appid=\(token)&q=\(city)"
        
        weatherClient.getWeather(with: urlString) { (weatherModel, _ error) in
            self.weatherModel = weatherModel
            self.delegate?.didLoadData()
        }
    }
}
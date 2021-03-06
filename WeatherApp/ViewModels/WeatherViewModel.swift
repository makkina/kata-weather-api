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
    private(set) var weatherModel: WeatherModel?
    private var weatherClient: WeatherClientProtocol
    private let validCities: [String]
    
    // MARK: - View Properties
    
    var weatherLabelText: String {
        guard weatherModel?.temperature != nil else {
            return Constants.degreesCelcius
        }
        return String(format: "%.1f \(Constants.degreesCelcius)", weatherModel!.temperature)
    }
    
    var weatherLabelIsHidden: Bool {
        return weatherClient.isLoading()
    }
    
    var weatherConditionName: String {
        guard weatherModel?.conditionId != nil else {
            return "sun.min"
        }
        
        switch weatherModel!.conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    // MARK: - Init
    
    init(weatherClient: WeatherClientProtocol) {
        self.weatherClient = weatherClient
        self.validCities = Constants.validCities
    }
    
    func fetchWeather(city: String) {
        delegate?.willLoadData()
        
        // Check for valid city
        guard validCities.contains(city) else {
            weatherModel = nil
            delegate?.didLoadData()
            return
        }
        
        // Create Url
        let baseUrl = Constants.baseURL
        let token = Secrets.openWeatherTestToken
        let urlString = "\(baseUrl)&appid=\(token)&q=\(city)"
        
        weatherClient.getWeather(with: urlString) { (weatherModel, _ error) in
            self.weatherModel = weatherModel
            self.delegate?.didLoadData()
        }
    }
}

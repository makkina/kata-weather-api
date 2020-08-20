//
//  WeatherClient.swift
//  WeatherApp
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import Foundation

final class WeatherClient: WeatherClientProtocol {
    
    private let networkClient: NetworkClientProtocol
    private let decoder: JSONDecoder
    
    init(networkClient: NetworkClientProtocol, decoder: JSONDecoder) {
        self.networkClient = networkClient
        self.decoder = decoder
    }
    
    func getWeather(with urlString: String, completion: @escaping ((WeatherModel?, Error?) -> Void)) {
        networkClient.get(urlString: urlString) { (data, error) in
            completion(self.createWeatherModel(from: data), error)
        }
    }
}

// MARK: - Helpers

extension WeatherClient {
    
    convenience init(networkClient: NetworkClientProtocol) {
        self.init(networkClient: networkClient, decoder: JSONDecoder())
    }
    
    internal func createWeatherModel(from data: Data?) -> WeatherModel? {
        
        guard let safeData = data else { return nil }
        
        guard let weatherModelDTO = try? decoder.decode(WeatherModelDTO.self, from: safeData) else { return nil }

        return WeatherModelDTOMapper.map(weatherModelDTO)
    }
}

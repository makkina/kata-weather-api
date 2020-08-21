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
    var state: State
    
    init(networkClient: NetworkClientProtocol, decoder: JSONDecoder, state: State) {
        self.networkClient = networkClient
        self.decoder = decoder
        self.state = state
    }
    
    func getWeather(with urlString: String, completion: @escaping ((WeatherModel?, Error?) -> Void)) {
        state = .loading
        networkClient.get(urlString: urlString) { (data, error) in
            self.state = .notLoading
            completion(self.createWeatherModel(from: data), error)
        }
    }
}

// MARK: - Helpers

extension WeatherClient {
    
    convenience init(networkClient: NetworkClientProtocol) {
        self.init(networkClient: networkClient, decoder: JSONDecoder(), state: .notLoading)
    }
    
    private func createWeatherModel(from data: Data?) -> WeatherModel? {
        
        guard let safeData = data else { return nil }
        
        guard let weatherModelDTO = try? decoder.decode(WeatherModelDTO.self, from: safeData) else { return nil }

        return WeatherModelDTOMapper.map(weatherModelDTO)
    }
    
    func isLoading() -> Bool {
        return self.state.isLoading
    }
}

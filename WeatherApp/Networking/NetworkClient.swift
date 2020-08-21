//
//  NetworkClient.swift
//  WeatherApp
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import Foundation

// MARK: - Class Implementation

final class NetworkClient: NetworkClientProtocol {
    
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    func get(urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        if let safeUrl = URL(string: urlString) {
            let request = generateGetRequestURL(url: safeUrl)
            let dataTask = urlSession.dataTask(with: request) { (responseData, _ urlResponse, responseError) in
                DispatchQueue.main.async {
                    completion(responseData, responseError)
                }
            }
            dataTask.resume()
        }
    }
}

// MARK: - Helpers

extension NetworkClient {

    convenience init() {
        self.init(urlSession: URLSession(configuration: URLSessionConfiguration.default))
    }
    
    private func generateGetRequestURL(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}

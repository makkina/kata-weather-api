//
//  URLSessionProtocol.swift
//  WeatherApp
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import Foundation

typealias URLSessionDataTaskCompletion = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol: AnyObject {
    func dataTask(
        with request: URLRequest,
        completion: @escaping URLSessionDataTaskCompletion) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {

    func dataTask(
        with request: URLRequest,
        completion: @escaping URLSessionDataTaskCompletion) -> URLSessionDataTaskProtocol {
        
        return dataTask(with: request, completionHandler: completion) as URLSessionDataTaskProtocol
    }
}

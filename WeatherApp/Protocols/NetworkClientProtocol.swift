//
//  NetworkClientProtocol.swift
//  WeatherApp
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import Foundation

protocol NetworkClientProtocol {
    func get(
        urlString: String,
        completion: @escaping (Data?, Error?) -> Void
    )
}

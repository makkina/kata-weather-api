//
//  State.swift
//  WeatherApp
//
//  Created by Makkina on 21/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import Foundation

enum State {
    case loading
    case notLoading
    
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        case .notLoading:
            return false
        }
    }
}

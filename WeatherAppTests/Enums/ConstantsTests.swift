//
//  ConstantsTests.swift
//  WeatherAppTests
//
//  Created by Makkina on 21/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import XCTest
@testable import WeatherApp

class ConstantsTests: XCTestCase {
    
    func testBaseUrl() {
        XCTAssertEqual("https://api.openweathermap.org/data/2.5/weather?units=metric", Constants.baseURL)
    }

    func testDegreesCelcius() {
        XCTAssertEqual("°C", Constants.degreesCelcius)
    }
    
    func testValidCities() {
        XCTAssertEqual(["Antwerp", "Brussels", "Ghent"], Constants.validCities)
    }
}

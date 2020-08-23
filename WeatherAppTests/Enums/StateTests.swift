//
//  StateTests.swift
//  WeatherAppTests
//
//  Created by Makkina on 23/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import XCTest
@testable import WeatherApp

class StateTests: XCTestCase {
    
    func testStateIsNotLoading() {
        // given
        var state: State = .loading
        // when
        state = .notLoading
        // then
        XCTAssertFalse(state.isLoading)
    }
    
    func testStateIsLoading() {
        // given
        var state: State = .notLoading
        // when
        state = .loading
        // then
        XCTAssertTrue(state.isLoading)
    }
}

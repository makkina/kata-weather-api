//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import XCTest

class WeatherAppUITests: XCTestCase {

       var app: XCUIApplication!
    
       override func setUpWithError() throws {
           super.setUp()
           app = XCUIApplication()
           app.launchArguments += ["-enableTestMode", "1"]
           app.launch()
           continueAfterFailure = false
       }
       
       override func tearDownWithError() throws {
           super.tearDown()
           app.terminate()
           app = nil
       }
       
       func testUIHasThreeButtons() throws {
           for i in 1...3 {
               let btn = app.buttons["weatherButton \(i)"]
               XCTAssertTrue(btn.waitForExistence(timeout: 1))
           }
       }
       
       func testThreeButtonsCanBePressed() {
           for i in 1...3 {
               let btn = app.buttons["weatherButton \(i)"]
               btn.tap()
               XCTAssertTrue(btn.isHittable)
           }
       }
       
       func testWeatherLabelIsEmpty() {
           XCTAssert(app.staticTexts["°C"].exists)
       }
       
       func testWeatherLabelIsVisible() {
           let weatherLabel = app.staticTexts.element(matching: .any, identifier: "weatherLabel").label
           XCTAssertEqual(weatherLabel, "°C")
       }
       
       func testCityButtonOneIsAntwerp() {
           let btn = app.buttons["weatherButton 1"]
           
           XCTAssertEqual(btn.label, "Antwerp")
       }
       
       func testCityButtonTwoIsBrussels() {
           let btn = app.buttons["weatherButton 2"]

           XCTAssertEqual(btn.label, "Brussels")
       }
       
       func testCityButtonThreeIsGhent() {
           let btn = app.buttons["weatherButton 3"]
           
           XCTAssertEqual(btn.label, "Ghent")
       }
       
       func testWeatherLabelChangesAfterButtonPress() {
           let mainView = app.otherElements["MainView"]
           let random = Int.random(in: 1...3)
           let btn = app.buttons["weatherButton \(random)"]
           let screenshotBefore = mainView.screenshot()
           
           btn.tap()
           sleep(1)
           
           let screenshotAfter = mainView.screenshot()
           XCTAssertNotEqual(screenshotBefore.pngRepresentation, screenshotAfter.pngRepresentation)
       }
       
       func testTempuratureCelciusAppearsOnScreenAfterButtonPress() {
           let random = Int.random(in: 1...3)
           app.buttons["weatherButton \(random)"].tap()
           sleep(1)
       
           var weatherInCelcius = app.staticTexts.element(matching: .any, identifier: "weatherLabel").label
           
           if let celcius = weatherInCelcius.popLast(),
               let degrees = weatherInCelcius.popLast() {
               
               let degreesCelcius = "\(degrees)\(celcius)"
               XCTAssertEqual(degreesCelcius, "°C")
           }
       }
       
       func testWeatherConditionImage() {
           let image = app.images["weatherConditionView"]
           XCTAssert(image.exists)
       }
}

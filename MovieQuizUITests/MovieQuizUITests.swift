//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Андрей Тапалов on 11.12.2023.
//

import XCTest

//MARK: - Base
class BaseClass: XCTestCase {
    let app = XCUIApplication()
    override func setUpWithError() throws {
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        app.terminate()
    }
}
//MARK: - Elements
class UIElements: BaseClass {
    
    var indexLabel: XCUIElement {app.staticTexts["Index"]}
    var firstPoster: XCUIElement { app.images["Poster"]}
    var secondPoster: XCUIElement {app.images["Poster"]}
    var buttonYes: XCUIElement {app.buttons["Yes"]}
    var buttonNo: XCUIElement {app.buttons["No"]}
    var alert: XCUIElement {app.alerts.firstMatch}
    var alertTitle: XCUIElement {app.alerts.firstMatch.staticTexts["Этот раунд окончен!"]}
    var alertButton: XCUIElement {app.alerts.buttons["Сыграть ещё раз"]}
}


//MARK: - Tests
class MovieQuizUITests {
    let uiElements = UIElements()
    
    func testYesButton() throws {
        _ = uiElements.firstPoster.waitForExistence(timeout: 3)
        let firstPosterData = uiElements.firstPoster.screenshot().pngRepresentation
        uiElements.buttonYes.tap()
        sleep(3)
        let secondPosterData = uiElements.secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(uiElements.indexLabel.label, "2/10")
    }
    
    func testNoButton() throws {
        _ = uiElements.firstPoster.waitForExistence(timeout: 3)
        let firstPosterData = uiElements.firstPoster.screenshot().pngRepresentation
        uiElements.buttonNo.tap()
        sleep(3)
        let secondPosterData = uiElements.secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(uiElements.indexLabel.label, "2/10")
        
    }
    
    func testTextAlert() throws {
        _ = uiElements.buttonYes.waitForExistence(timeout: 3)
        for _ in 0...9 {
            uiElements.buttonYes.tap()
            sleep(3)
        }
        
        XCTAssertEqual(uiElements.alert.waitForExistence(timeout: 3), true)
        XCTAssertEqual(uiElements.alertTitle.label, "Этот раунд окончен!")
        XCTAssertEqual(uiElements.alertButton.label, "Сыграть ещё раз")
        
    }
    
    
}

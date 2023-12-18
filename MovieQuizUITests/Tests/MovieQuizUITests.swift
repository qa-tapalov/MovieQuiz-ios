//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Андрей Тапалов on 11.12.2023.
//

import XCTest

//MARK: - Tests
class MovieQuizUITests: BaseClass {
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
        
        XCTAssertTrue(uiElements.alert.exists)
        XCTAssertEqual(uiElements.alertTitle.label, "Этот раунд окончен!")
        XCTAssertEqual(uiElements.alertButton.label, "Сыграть ещё раз")
        
    }
    
    func testAlertButtonPlayAgain() throws {
        _ = uiElements.buttonYes.waitForExistence(timeout: 3)
        for _ in 0...9 {
            uiElements.buttonYes.tap()
            sleep(3)
        }
        
        uiElements.alertButton.tap()
        _ = uiElements.indexLabel.waitForExistence(timeout: 3)
        XCTAssertEqual(uiElements.indexLabel.label, "1/10")

    }
    
}

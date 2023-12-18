//
//  BaseClass.swift
//  MovieQuizUITests
//
//  Created by Андрей Тапалов on 17.12.2023.
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

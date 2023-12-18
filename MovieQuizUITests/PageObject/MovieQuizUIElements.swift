//
//  MovieQuizUIElements.swift
//  MovieQuizUITests
//
//  Created by Андрей Тапалов on 17.12.2023.
//

import XCTest

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

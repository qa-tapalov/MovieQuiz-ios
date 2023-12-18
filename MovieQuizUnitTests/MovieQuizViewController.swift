//
//  MovieQuizViewControllerMock.swift
//  MovieQuizUITests
//
//  Created by Андрей Тапалов on 17.12.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuiz.MovieQuizViewControllerProtocol{
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func showAlert(quiz result: MovieQuiz.QuizResultsViewModel) {
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showNetworkError(message: String) {
        
    }
    
    func toggleButton() {
        
    }
    
    
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuiz.MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = MovieQuiz.QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}

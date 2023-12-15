//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Андрей Тапалов on 15.12.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    
    private var currentQuestionIndex: Int = .zero
    let questionsAmount = 10
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = .zero
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
}

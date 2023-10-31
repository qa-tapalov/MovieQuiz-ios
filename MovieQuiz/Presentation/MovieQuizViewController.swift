import UIKit

//View Models
struct ViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}


final class MovieQuizViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    //MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText,style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.show(quiz: self.convert(model: self.questions[self.currentQuestionIndex]))
            self.imageView.layer.borderWidth = 0
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
           show(quiz: QuizResultsViewModel(title: "Раунд окончен!",
                                           text: "Ваш результат: \(correctAnswers)/10",
                                           buttonText: "Сыграть ещё раз"))
        } else {
            currentQuestionIndex += 1
            show(quiz: convert(model: questions[currentQuestionIndex]))
            imageView.layer.borderWidth = 0
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        show(quiz: convert(model: questions[currentQuestionIndex]))
        super.viewDidLoad()
    }
}

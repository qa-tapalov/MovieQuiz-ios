import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    //MARK: - Outlets
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    
    //MARK: - Private properties
    private var currentQuestionIndex: Int = .zero
    private var correctAnswers: Int = .zero
    private let questionsAmount: Int = 10
    private let questionFactory = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    private lazy var alertPresenter: AlertPresenterDelegate = AlertPresenter(view: self)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        questionFactory.delegate = self
        questionFactory.requestNextQuestion()
        super.viewDidLoad()
    }
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    //MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    //MARK: - Private Methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        noButton.isEnabled.toggle()
        yesButton.isEnabled.toggle()
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            
            guard let self else {return}
            self.showNextQuestionOrResults()
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = .zero
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            alertPresenter.presentAlert(alertModel: AlertModel(title: "Раунд окончен!",
                                                               message: text,
                                                               buttonText: "Сыграть ещё раз", 
                                                               completion: {
                [weak self] in
                guard let self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory.requestNextQuestion()
            }))
        } else {
            currentQuestionIndex += 1
            self.questionFactory.requestNextQuestion()
        }
        noButton.isEnabled.toggle()
        yesButton.isEnabled.toggle()
    }
}

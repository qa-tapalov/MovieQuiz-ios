import UIKit

final class MovieQuizViewController: UIViewController,
                                     QuestionFactoryDelegate {
    //MARK: - Outlets
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: - Private properties
    private var currentQuestionIndex: Int = .zero
    private var correctAnswers: Int = .zero
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactory?
    private var currentQuestion: QuizQuestion?
    private lazy var alertPresenter: AlertPresenterDelegate = AlertPresenter(view: self)
    private var statisticService: StatisticService = StatisticServiceImplementation()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        showLoadingIndicator()
        questionFactory?.loadData()
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
            image: UIImage(data: model.image) ?? UIImage(),
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
    
    private func showAlert(quiz: QuizResultsViewModel){
        alertPresenter.presentAlert(alertModel: AlertModel(title:quiz.title,
                                                           message: quiz.text,
                                                           buttonText: quiz.buttonText,
                                                           completion: {
            [weak self] in
            guard let self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }))
    }
    
    private func generateResultText() -> String {
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let recordText = statisticService.bestGame.textRecord
        let averageAccuracyLine = "Средняя точность: \(accuracy)%"
        let message = [currentGameResultLine,totalPlaysCountLine,recordText, averageAccuracyLine].joined(separator: "\n")
        return message
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            showAlert(quiz: QuizResultsViewModel(title: "Этот раунд окончен!",
                                                 text: generateResultText(),
                                                 buttonText: "Сыграть ещё раз"))
        } else {
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
        noButton.isEnabled.toggle()
        yesButton.isEnabled.toggle()
    }
    
}

extension MovieQuizViewController {
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        alertPresenter.presentAlert(alertModel: AlertModel(title: "Ошибка",
                                                           message: "Не удалось загрузить данные",
                                                           buttonText: "Попробовать ещё раз",
                                                           completion: {
            [weak self] in
            guard let self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.loadData()
        }))
    }
}

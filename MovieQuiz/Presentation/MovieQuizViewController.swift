import UIKit

final class MovieQuizViewController: UIViewController,
                                     MovieQuizViewControllerProtocol {
    //MARK: - Outlets
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: - Private properties
    private var presenter: MovieQuizPresenter!
    private lazy var alertPresenter: AlertPresenterDelegate = AlertPresenter(view: self)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        presenter = MovieQuizPresenter(viewController: self)
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
        toggleButton()
    }
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
        toggleButton()
    }
    
    //MARK: - Methods
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = .zero
    }
    
    func showAlert(quiz: QuizResultsViewModel){
        alertPresenter.presentAlert(alertModel: AlertModel(title:quiz.title,
                                                           message: quiz.text,
                                                           buttonText: quiz.buttonText,
                                                           completion: {
            [weak self] in
            guard let self else { return }
            self.presenter.restartGame()
        }))
    }
    
}

//MARK: - Extension
extension MovieQuizViewController {
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        alertPresenter.presentAlert(alertModel: AlertModel(title: "Ошибка",
                                                           message: "Не удалось загрузить данные",
                                                           buttonText: "Попробовать ещё раз",
                                                           completion: {
            [weak self] in
            guard let self else { return }
            self.presenter.restartGame()
        }))
    }
    
    func toggleButton(){
        yesButton.isEnabled.toggle()
        noButton.isEnabled.toggle()
    }
}

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showAlert(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    func toggleButton()
}

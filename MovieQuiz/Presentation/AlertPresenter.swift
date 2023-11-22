//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Андрей Тапалов on 17.11.2023.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func presentAlert(alertModel: AlertModel)
}

final class AlertPresenter: AlertPresenterDelegate {
    
    private let view: UIViewController
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func presentAlert(alertModel: AlertModel) {
        let alertController = UIAlertController(title: alertModel.title,
                                                message: alertModel.message,
                                                preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText,
                                   style: .default) { _ in
            alertModel.completion()
        }
        alertController.addAction(action)
        view.present(alertController, animated: true, completion: nil)
    }
    
    
}



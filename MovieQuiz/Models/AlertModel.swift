//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Андрей Тапалов on 17.11.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}

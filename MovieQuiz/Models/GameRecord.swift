//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Андрей Тапалов on 20.11.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    var textRecord: String {
        "Рекорд: \(correct)\\\(total)(\(date.dateTimeString))"
    }
    
    func isNewRecord(record: GameRecord) -> Bool {
        correct > record.correct
    }
    
}

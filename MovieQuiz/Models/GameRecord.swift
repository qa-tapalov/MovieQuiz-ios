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

extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.accuracy < rhs.accuracy
    }
    
    private var accuracy: Double {
        guard total != 0 else {
            return 0
        }
        return Double(correct) / Double(total)
        
        
    }
}

//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Андрей Тапалов on 10.12.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        let array = [1,2,3,4,5]
        
        let value = array[safe: 2]
    }
    
    func testGetValueOutOfRange() throws {
        let array = [1,2,3,4,5]
        
        let value = array[safe: 20]
    }
}

//
//  CheckAnswerItem.swift
//  Quiz
//
//  Created by d004 DIT UPM on 17/12/24.
//

import Foundation

struct CheckAnswerItem: Codable{
    let quizId: Int
    let answer: String
    let result: Bool
}

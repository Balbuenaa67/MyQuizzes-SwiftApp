//
//  ScoreModel.swift
//  Quiz
//
//  Created by d004 DIT UPM on 28/11/24.
//

import Foundation

@Observable class ScoresModel{
    
    private(set) var acertadas: Set<Int> = []
    private(set) var record: Set<Int> = []

    init() {
        record = Set(UserDefaults.standard.array(forKey: "record") as? [Int] ?? [])
    }

    func meter(_ quizItem: QuizItem) {
        acertadas.insert(quizItem.id)
        record.insert(quizItem.id)

        UserDefaults.standard.set(Array(record), forKey: "record")
    }

    func limpiar() {
        acertadas.removeAll()
    }
    
}

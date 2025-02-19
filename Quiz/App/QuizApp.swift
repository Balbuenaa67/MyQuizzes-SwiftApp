//
//  QuizApp.swift
//  Quiz
//
//  Created by d004 DIT UPM on 28/11/24.
//
import SwiftUI

@main
struct QuizApp: App {
    @State var quizzesModel = QuizzesModel()
    @State var scoresModel = ScoresModel()
    //probando
    //@StateObject var scoreModel = ScoreModel()
    
    var body: some Scene {
        WindowGroup {
            
            QuizzesView()
                .environment(quizzesModel)
                .environment(scoresModel)
        }
    }
}

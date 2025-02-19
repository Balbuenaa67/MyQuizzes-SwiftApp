//
//  QuizzesView.swift
//  Quiz
//
//  Created by d004 DIT UPM on 28/11/24.
//

import SwiftUI

struct QuizzesView : View {
    
    @Environment(QuizzesModel.self) var quizzesModel: QuizzesModel
    @Environment(ScoresModel.self) var scoresModel
    
    @State var showAll: Bool = true//OJO
    
    var body: some View {
        NavigationStack{
            List {
                Toggle("Show all", isOn: $showAll.animation(.easeInOut))
                
                ForEach(quizzesModel.quizzes) {quizItem in
                    if showAll || !scoresModel.acertadas.contains(quizItem.id){
                        NavigationLink(destination: QuizPlayView(quizItem: quizItem)){
                            QuizRowView(quizItem: quizItem)
                        }
                    }
                }  
            }
            .listStyle(.plain)
            .toolbar{
                ToolbarItemGroup(placement: .topBarLeading) {
                    HStack{
                        Image(systemName: "hand.thumbsup")
                        Text("\(scoresModel.acertadas.count) of \(quizzesModel.quizzes.count)")
                        Image(systemName: "medal")
                        Text("\(scoresModel.record.count)")
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing){
                    Button("reload") {
                        Task {
                            await quizzesModel.download()
                            scoresModel.limpiar()
                        }
                    }
                }
            }
            .navigationTitle("Quizzes")
        }
        .padding()
        .task {
            print("Estoy cargando los datos")
            if quizzesModel.quizzes.count == 0{
                try? await quizzesModel.download()
            }
        }
    }     
}

#Preview {

    @Previewable @State var model = QuizzesModel()
    @Previewable @State var model2 = ScoresModel()

    
    QuizzesView()
        .environment(model)
        .environment(model2)

}


//
//  QuizRowView.swift
//  Quiz
//
//  Created by d004 DIT UPM on 28/11/24.
//

import SwiftUI

struct QuizRowView: View{
   
    var quizItem: QuizItem
    
    var body: some View{
    
        HStack{
            EasyAsyncImage(url: quizItem.attachment?.url)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay{
                    RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 6)
                }
                .shadow(radius: 10)

            VStack(alignment: .trailing){

                Image(quizItem.favourite ? "syellow" : "sgrey")
                    .resizable()
                    .frame(width: 15, height: 15)
                Text(quizItem.question)
                    .lineLimit(3)
                    .font(.headline)

                HStack {
                    Spacer()
                    Text(quizItem.author?.username ??
                    quizItem.author?.profileName ??
                        "Anonimo")

                    EasyAsyncImage(url: quizItem.author?.photo?.url)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay{
                            Circle().stroke(Color.red, lineWidth: 1)
                        }

                }
            }
            .padding()

        }       
    }
}

#Preview{
    @Previewable @State var quizzesModel = QuizzesModel()
    
    let _ = quizzesModel.load()
    
    QuizRowView(quizItem: quizzesModel.quizzes[10])
}

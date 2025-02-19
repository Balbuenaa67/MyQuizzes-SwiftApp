//
//  PlayQuizView.swift
//  Quiz
//
//  Created by d004 DIT UPM on 28/11/24.
//

import SwiftUI

struct QuizPlayView: View{
    
    @Environment(ScoresModel.self) var scoresModel
    @Environment(QuizzesModel.self) var quizzesModel: QuizzesModel

    @Environment(\.verticalSizeClass) var vsc

    @State var showAlertResultRespuesta: Bool = false
    @State var resultCheckRespuesta = false
    @State var waitingCheckRespuesta: Bool = false

    @State var showAlertError: Bool = false
    
    @State var showPuntos: Bool = false

    @State var msgError: String = "" {
        didSet {
            showAlertError = true
        }
    }

    @State var respuesta: String = ""

    var quizItem: QuizItem

    var body: some View{
        VStack{
            if vsc != .compact {
                VStack(alignment: .center){
                    HStack{
                        cabecera
                        estrella
                    }
                    respuestaView
                    adjunto
                    autor
                }
            } else {
                VStack {
                    HStack{
                        cabecera
                        estrella
                    }
                    respuestaView
                    HStack(alignment: .center){
                        adjunto
                        autor
                    }
                }
            }
        }
        .alert("Error", isPresented: $showAlertError){

        } message: {
            Text(msgError)
        }
    }

     var respuestaView: some View {
         VStack{
             TextField("Respuesta", text: $respuesta)
                 .onSubmit{
                     checkAnswer()
                 }
                 .alert(resultCheckRespuesta ? "Bien" : "Mal", isPresented: $showAlertResultRespuesta) {

                 }
                 .textFieldStyle(.roundedBorder)
             
             if waitingCheckRespuesta {
                ProgressView()
             } else {
                HStack{
                    Image("interrogacion")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Button("Comprobar"){
                        checkAnswer()
                    }
                }
             }
         }
     }

     func checkAnswer() {
        waitingCheckRespuesta = true
        Task {
            try await Task.sleep(for: .seconds(1))
            do {
                if try await quizzesModel.checkAnswer(quizId: quizItem.id, answer: respuesta) {
                    showAlertResultRespuesta = true
                    resultCheckRespuesta = true
                    scoresModel.meter(quizItem)
                } else {
                    showAlertResultRespuesta = true
                    resultCheckRespuesta = false
                }
                waitingCheckRespuesta = false
            } catch {
                msgError = error.localizedDescription
                waitingCheckRespuesta = false
            }
        }
     }

     var cabecera: some View{
         HStack{
             Text(quizItem.question)
                 .lineLimit(3)
                 .font(.largeTitle)
         }
     }

    @State private var tappedImageScale: CGFloat = 1.0  // Controla la escala de la imagen
    @State private var tappedImageOpacity: Double = 1.0  // Controla la opacidad de la imagen
    
    var adjunto: some View {
        GeometryReader { geom in
            EasyAsyncImage(url: quizItem.attachment?.url)
                .frame(width: geom.size.width, height: geom.size.height)
                .clipShape(RoundedRectangle(cornerRadius: 19))
                .contentShape(RoundedRectangle(cornerRadius: 19))
                .overlay {
                    RoundedRectangle(cornerRadius: 19).stroke(Color.blue, lineWidth: 15)
                }
                .shadow(radius: 10)
                .onTapGesture(count: 2) {
                    Task {
                        // Animación de escala y opacidad al tocar
                        withAnimation(.easeIn(duration: 0.2)) {
                            // Ejemplo de animación al inicio (desvanecimiento y zoom)
                            tappedImageScale = 0.95 // Reducimos un poco el tamaño
                            tappedImageOpacity = 0.7 // Hacemos que la imagen se desvanezca ligeramente
                        }

                        do {
                            let resp = try await quizzesModel.getAnswer(quizItem: quizItem)
                            respuesta = resp
                        } catch {
                            msgError = error.localizedDescription
                        }

                        // Animación de restauración después de la acción
                        withAnimation(.easeOut(duration: 0.3)) {
                            // Restauramos el tamaño original y opacidad después de obtener la respuesta
                            tappedImageScale = 1.0 // Restablecemos la escala
                            tappedImageOpacity = 1.0 // Restauramos la opacidad
                        }
                    }
                }
                .scaleEffect(tappedImageScale) // Aplicamos el efecto de escala
                .opacity(tappedImageOpacity) // Aplicamos el efecto de opacidad
        }
        .padding()
    }

     var autor: some View{
         VStack(alignment: .trailing){
                 HStack{
                     Spacer()
                     Text(quizItem.author?.username ?? quizItem.author?.profileName ?? "Anonimo")

                     EasyAsyncImage(url: quizItem.author?.photo?.url)
                         .frame(width: 60, height: 60)
                         .clipShape(Circle())
                         .overlay{
                             Circle().stroke(Color.red, lineWidth: 1)
                         }
                         .contextMenu(ContextMenu(menuItems: {
                             Button(action: {
                                 respuesta = ""
                             }, label:{
                                 Label ("Limpiar", systemImage: "x.circle")
                             })
                             Button(action: {
                                 Task{
                                     do{
                                         let aux = try await quizzesModel.getAnswer(quizItem: quizItem)
                                         respuesta = aux
                                     } catch {
                                         throw QuizzesModelError.corruptedDataError
                                     }
                                 }
                             }, label:{
                                 Label ("Solución", systemImage: "square.and.arrow.up.on.square")
                             })
                         }))

                 }
         }
     }
    
    var estrella: some View {
        Button{
            Task{
                do {
                    try await quizzesModel.toggleFavourite(quizItem: quizItem, quizId: quizItem.id)
                } catch {
                    throw QuizzesModelError.corruptedDataError
                }
            }
        }label:{
            Image(quizItem.favourite ? "syellow" : "sgrey")
                .resizable()
                .frame(width:25, height: 25)
                .clipped()
                .scaledToFill()
        }
    }

}

#Preview{
     @Previewable @State var quizzesModel = QuizzesModel()
     @Previewable @State var scoresModel = ScoresModel()
    
    let _ = quizzesModel.load()
    
    QuizPlayView(quizItem: quizzesModel.quizzes[14])
        .environment(scoresModel)
}

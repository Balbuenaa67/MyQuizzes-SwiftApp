//
//  QuizzesModel.swift
//  Quiz
//
//  Created by Santiago Pavón Gómez on 18/10/24.
//

import Foundation

/// Errores producidos en el modelo de los Quizzes
//enum QuizzesModelError: LocalizedError {
//    case internalError(msg: String)
//    case corruptedDataError
//    case unknownError
//
//    var errorDescription: String? {
//        switch self {
//        case .internalError(let msg):
//            return "Error interno: \(msg)"
//        case .corruptedDataError:
//            return "Recibidos datos corruptos"
//        case .unknownError:
//            return "No chungo ha pasado"
//       }
//    }
//}

@Observable class QuizzesModel {
    
    // Los datos
    private(set) var quizzes = [QuizItem]()

    init(){
        print("Cache 0 ==>", URLCache.shared.memoryCapacity/1024, "KB")
        URLCache.shared.memoryCapacity = 250+1000+1000
        print("Cache 1 ==>", URLCache.shared.memoryCapacity/1024, "KB")
    }
    
    func download() async {
        do {
            let r10URL = try EndPoints.r10()
            
            let (data, response) = try await URLSession.shared.data(from: r10URL)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200  else {
                throw QuizzesModelError.httpError(msg: "r10 prot http esta tonto")
            }
            print("Quizzes ==>", String(data: data, encoding: .utf8) ?? "JSON incorrecto")
            
            guard let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data)
                else{
                    throw QuizzesModelError.corruptedDataError
                }
            
            self.quizzes = quizzes
            print("Quizzes cargados")
        } catch {
            print(error.localizedDescription)
        }
    }

    func load() {
        do {
            guard let jsonURL = Bundle.main.url(forResource: "quizzes", withExtension: "json") else {
                throw QuizzesModelError.internalError(msg: "No encuentro quizzes.json")
            }
            
            let data = try Data(contentsOf: jsonURL)
            
            // print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
            
            guard let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data)  else {
                throw QuizzesModelError.corruptedDataError
            }
            
            self.quizzes = quizzes
            
            print("Quizzes cargados")
        } catch {
            print(error.localizedDescription)
        }
    }

    func checkAnswer(quizId: Int, answer: String) async throws -> Bool { //AÑADIDO EL BOOL
        
        let caURL = try EndPoints.checkAnswer(quizId: quizId, answer: answer)
            
        let (data, response) = try await URLSession.shared.data(from: caURL)
            
        guard (response as? HTTPURLResponse)?.statusCode == 200  else {
            throw QuizzesModelError.httpError(msg: "check Answer prot http esta fallando")
        }
        //print("Quizzes ==>", String(data: data, encoding: .utf8) ?? "JSON incorrecto")
            
        guard let checkAnswerItem = try? JSONDecoder().decode(CheckAnswerItem.self, from: data)
            else{
                throw QuizzesModelError.corruptedDataError
            }

        print("Answer comprobada")

        return checkAnswerItem.result
    }

    func toggleFavourite(quizItem: QuizItem, quizId: Int) async throws {
        
        guard let index = quizzes.firstIndex (where: {quiz in quiz.id == quizId}) else
        {
            throw QuizzesModelError.internalError(msg: "no puedes togglear el favorito de un quiz que no existe")
        }
        
        let tfURL = try EndPoints.favourite(quizId: quizItem.id)

        var urlRequest = URLRequest(url: tfURL)
        urlRequest.httpMethod = quizItem.favourite ? "DELETE" : "PUT"

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw QuizzesModelError.corruptedDataError
        }

        let favouriteItem = try JSONDecoder().decode(FavouriteItem.self, from: data)

        quizzes[index].favourite = favouriteItem.favourite
    }
    
    func getAnswer(quizItem: QuizItem) async throws -> String {
        
        guard let url = EndPoints.getAnswer(quizItem: quizItem) else {
            throw QuizzesModelError.comprobationError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200  else {
            throw QuizzesModelError.httpError(msg: "Error ruta")
        }
        
        // print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
        
        guard let res = try? JSONDecoder().decode(AnswerItem.self, from: data)  else {
            throw QuizzesModelError.corruptedDataError
        }
        
        return res.answer
        
    }

}

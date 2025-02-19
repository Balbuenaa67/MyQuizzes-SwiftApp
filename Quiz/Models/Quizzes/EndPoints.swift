import Foundation

struct EndPoints {

    private static let urlBase = "https://quiz.dit.upm.es/api"
    private static let token = UserDefaults.standard.string(forKey: "token") ?? "9050d337da98b1fac50f"

    static func r10() throws -> URL {

        let surl = "\(urlBase)/quizzes/random10?token=\(token)"

        guard let url = URL(string: surl) else {
            throw QuizzesModelError.internalError(msg: "la URL \(surl) no es valida")
        }

        return url
    }

    static func checkAnswer(quizId: Int, answer: String) throws -> URL {
        
        guard let answerEscaped = answer.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw QuizzesModelError.internalError(msg: "el parametro answer no es valido")
        }

        let surl = "\(urlBase)/quizzes/\(quizId)/check?token=\(token)&answer=\(answerEscaped)"

        guard let url = URL(string: surl) else {
            throw QuizzesModelError.internalError(msg: "la URL \(surl) no es valida")
        }

        return url
    }

    static func favourite(quizId: Int) throws -> URL {

        let surl = "\(urlBase)/users/tokenOwner/favourites/\(quizId)?token=\(token)"

        guard let url = URL(string: surl) else {
            throw QuizzesModelError.internalError(msg: "la URL \(surl) no es valida")
        }

        return url
    }
    
    static func getAnswer(quizItem: QuizItem) -> URL? {
        let ruta = "/quizzes/\(quizItem.id)/answer"
        let string = "\(urlBase)\(ruta)?token=\(token)"
        return URL(string: string)
    }

}

import Foundation

enum QuizzesModelError: LocalizedError {
    case internalError(msg: String)
    case corruptedDataError
    case httpError(msg: String)
    case unknownError
    case comprobationError

    var errorDescription: String? {
        switch self {
            case .internalError(let msg):
                return "Error interno: \(msg)"
            case .httpError(let msg):
                return "HTTP me ha sorprendido: \(msg)"
            case .corruptedDataError:
                return "Recibidos datos corruptos"
            case .unknownError:
                return "Algo chungo ha pasado"
        case .comprobationError:
            return "Error al comprobar"
        }
    }
}

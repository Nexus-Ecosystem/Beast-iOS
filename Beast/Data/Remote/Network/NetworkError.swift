import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case transport(Error)
    case httpError(
        statusCode: Int,
        data: Data
    )
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL de la solicitud no es válida."

        case .transport:
            return "No fue posible conectar con el servidor."

        case let .httpError(statusCode, _):
            switch statusCode {
            case 400:
                return "La solicitud no es válida."

            case 401:
                return "Correo o contraseña incorrectos."

            case 403:
                return "No tienes permiso para realizar esta operación."

            case 404:
                return "No se encontró el recurso solicitado."

            case 500...599:
                return "Ocurrió un problema en el servidor."

            default:
                return "Ocurrió un error en la solicitud."
            }

        case .decoding:
            return "No fue posible procesar la respuesta del servidor."
        }
    }
}

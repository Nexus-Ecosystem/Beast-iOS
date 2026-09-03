import Foundation

enum AuthError: LocalizedError {
    case invalidURL
    case encodingFailed
    case invalidResponse
    case invalidCredentials
    case userNotFound
    case badRequest
    case forbidden
    case serverError
    case decodingFailed
    case network(Error)
    case httpError(statusCode: Int, message: String?)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "No fue posible realizar la solicitud."

        case .encodingFailed:
            return "No fue posible procesar los datos."

        case .invalidResponse:
            return "El servidor devolvió una respuesta inválida."

        case .invalidCredentials:
            return "Correo o contraseña incorrectos."

        case .userNotFound:
            return "No encontramos una cuenta con estos datos."

        case .badRequest:
            return "Verifica los datos ingresados."

        case .forbidden:
            return "No tienes permiso para realizar esta operación."

        case .serverError:
            return "El servicio no está disponible en este momento."

        case .decodingFailed:
            return "No fue posible procesar la información de tu cuenta."

        case .network:
            return "Revisa tu conexión a internet e intenta nuevamente."

        case let .httpError(_, message):
            return message ?? "Ocurrió un error al iniciar sesión."
        }
    }
}

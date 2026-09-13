import Foundation

enum AppConfiguration {
    static var baseURL: String {
        guard
            let value = Bundle.main.object(
                forInfoDictionaryKey: "BASE_URL"
            ) as? String,
            !value.isEmpty,
            !value.contains("$(")
        else {
            fatalError(
                "BASE_URL no está configurada"
            )
        }

        return value
    }

    static func serviceURL(
        _ service: String
    ) -> String {
        guard
            var components = URLComponents(
                string: baseURL
            ),
            let host = components.host
        else {
            fatalError(
                "BASE_URL no es válida: \(baseURL)"
            )
        }

        components.host =
            "\(service)-\(host)"

        guard let url =
            components.url?.absoluteString
        else {
            fatalError(
                "No fue posible construir la URL para \(service)"
            )
        }

        return url
    }
}

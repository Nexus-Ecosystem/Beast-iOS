import Foundation

enum NetworkLogger {
    static func logRequest(_ request: URLRequest) {
        #if DEBUG
        print("")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("➡️ REQUEST [HTTP]")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

        if let method = request.httpMethod {
            print("Method: \(method)")
        }

        if let url = request.url?.absoluteString {
            print("URL: \(url)")
        }

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("")
            print("Headers:")

            headers.forEach { key, value in
                print("  \(key): \(value)")
            }
        }

        if let body = request.httpBody {
            print("")
            print("Body:")
            printFormattedJSON(data: body)
        }

        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("")
        #endif
    }

    static func logResponse(
        request: URLRequest,
        response: HTTPURLResponse,
        data: Data,
        duration: TimeInterval
    ) {
        #if DEBUG
        print("")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("⬅️ RESPONSE [HTTP]")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

        if let method = request.httpMethod {
            print("Method: \(method)")
        }

        if let url = request.url?.absoluteString {
            print("URL: \(url)")
        }

        print("Status: \(response.statusCode)")
        print(
            String(
                format: "Duration: %.3f s",
                duration
            )
        )

        print("")
        print("Body:")

        if data.isEmpty {
            print("<EMPTY BODY>")
        } else {
            printFormattedJSON(data: data)
        }

        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("")
        #endif
    }

    static func logError(
        request: URLRequest,
        error: Error
    ) {
        #if DEBUG
        print("")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("❌ ERROR [HTTP]")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

        if let method = request.httpMethod {
            print("Method: \(method)")
        }

        if let url = request.url?.absoluteString {
            print("URL: \(url)")
        }

        print("Error: \(error.localizedDescription)")
        print("Raw error: \(error)")

        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("")
        #endif
    }

    static func logFirebaseRequest(
        path: String,
        operation: String = "LISTEN"
    ) {
        #if DEBUG
        print("")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("➡️ REQUEST [FIRESTORE]")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("Operation: \(operation)")
        print("Path: \(path)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("")
        #endif
    }

    static func logFirebaseResponse(
        path: String,
        documents: [[String: Any]]
    ) {
        #if DEBUG
        print("")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("⬅️ RESPONSE [FIRESTORE]")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("Path: \(path)")
        print("Documents: \(documents.count)")
        print("")
        print("Payload:")

        printFormattedJSONObject(documents)

        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("")
        #endif
    }

    static func logFirebaseResponse(
        path: String,
        document: [String: Any]?
    ) {
        #if DEBUG
        print("")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("⬅️ RESPONSE [FIRESTORE]")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("Path: \(path)")
        print("")
        print("Payload:")

        if let document {
            printFormattedJSONObject(document)
        } else {
            print("<EMPTY>")
        }

        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("")
        #endif
    }

    static func logFirebaseError(
        path: String,
        error: Error
    ) {
        #if DEBUG
        print("")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("❌ ERROR [FIRESTORE]")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("Path: \(path)")
        print("Error: \(error.localizedDescription)")
        print("Raw error: \(error)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("")
        #endif
    }

    private static func printFormattedJSON(
        data: Data
    ) {
        guard
            let object = try? JSONSerialization.jsonObject(with: data),
            let formattedData = try? JSONSerialization.data(
                withJSONObject: object,
                options: [.prettyPrinted, .sortedKeys]
            ),
            let text = String(
                data: formattedData,
                encoding: .utf8
            )
        else {
            print(
                String(
                    data: data,
                    encoding: .utf8
                ) ?? "<UNREADABLE BODY>"
            )
            return
        }

        print(text)
    }

    private static func printFormattedJSONObject(
        _ object: Any
    ) {
        guard
            JSONSerialization.isValidJSONObject(object),
            let data = try? JSONSerialization.data(
                withJSONObject: object,
                options: [.prettyPrinted, .sortedKeys]
            ),
            let text = String(
                data: data,
                encoding: .utf8
            )
        else {
            print(String(describing: object))
            return
        }

        print(text)
    }
}

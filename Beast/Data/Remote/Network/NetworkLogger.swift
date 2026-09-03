import Foundation

enum NetworkLogger {
    static func logRequest(_ request: URLRequest) {
        #if DEBUG
        print("")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("➡️ REQUEST")
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
        print("⬅️ RESPONSE")
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
        print("❌ NETWORK ERROR")
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

    private static func printFormattedJSON(data: Data) {
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
}

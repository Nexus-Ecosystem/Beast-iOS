import SwiftUI
import PDFKit

struct ResponsivePDFView: View {
    let urlString: String

    @State private var localURL:
        URL?

    @State private var isLoading = true

    @State private var errorMessage = ""

    @State private var showError = false

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            if let localURL {
                PDFKitView(
                    url: localURL
                )
                .ignoresSafeArea(
                    edges: .bottom
                )
            }

            if isLoading {
                BeastLoadingOverlay(
                    message:
                        "Cargando responsiva..."
                )
            }

            if showError {
                BeastAlertDialog(
                    style: .error,
                    title:
                        "¡Atención!",
                    message:
                        errorMessage,
                    buttonTitle:
                        "Entendido"
                ) {
                    showError = false
                }
            }
        }
        .navigationTitle(
            "RESPONSIVA-BEAST.pdf"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
        .toolbar(
            .hidden,
            for: .tabBar
        )
        .task {
            await downloadPDF()
        }
    }

    private func downloadPDF() async {
        guard let url =
            URL(
                string: urlString
            )
        else {
            errorMessage =
                "La URL de la responsiva no es válida."

            showError = true
            isLoading = false
            return
        }

        var request =
            URLRequest(
                url: url
            )

        request.httpMethod =
            "GET"

        NetworkLogger.logRequest(
            request
        )

        let startTime =
            Date()

        do {
            let (
                data,
                response
            ) = try await URLSession
                .shared
                .data(
                    for: request
                )

            guard let httpResponse =
                response as? HTTPURLResponse
            else {
                throw URLError(
                    .badServerResponse
                )
            }

            NetworkLogger.logResponse(
                request: request,
                response: httpResponse,
                data: data,
                duration:
                    Date()
                        .timeIntervalSince(
                            startTime
                        )
            )

            guard
                200..<300 ~= httpResponse.statusCode
            else {
                throw URLError(
                    .badServerResponse
                )
            }

            let fileURL =
                FileManager.default
                    .temporaryDirectory
                    .appendingPathComponent(
                        "RESPONSIVA-BEAST.pdf"
                    )

            try data.write(
                to: fileURL,
                options: .atomic
            )

            localURL =
                fileURL

            isLoading =
                false
        } catch {
            NetworkLogger.logError(
                request: request,
                error: error
            )

            errorMessage =
                error.localizedDescription

            showError = true
            isLoading = false
        }
    }
}

private struct PDFKitView:
    UIViewRepresentable
{
    let url: URL

    func makeUIView(
        context: Context
    ) -> PDFView {
        let pdfView =
            PDFView()

        pdfView.autoScales =
            true

        pdfView.displayMode =
            .singlePageContinuous

        pdfView.displayDirection =
            .vertical

        pdfView.backgroundColor =
            .systemBackground

        pdfView.document =
            PDFDocument(
                url: url
            )

        return pdfView
    }

    func updateUIView(
        _ uiView: PDFView,
        context: Context
    ) {}
}

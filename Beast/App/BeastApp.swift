import SwiftUI
import FirebaseCore

@main
struct BeastApp: App {

    init() {
        configureFirebase()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }

    private func configureFirebase() {
        guard
            let configName = Bundle.main.object(
                forInfoDictionaryKey: "FIREBASE_CONFIG"
            ) as? String,
            let filePath = Bundle.main.path(
                forResource: configName,
                ofType: "plist"
            ),
            let options = FirebaseOptions(
                contentsOfFile: filePath
            )
        else {
            fatalError("No se encontró la configuración de Firebase")
        }

        FirebaseApp.configure(options: options)

        print("""
        🔥 FIREBASE CONFIGURADO
        config: \(configName)
        projectID: \(options.projectID ?? "nil")
        storageBucket: \(options.storageBucket ?? "nil")
        """)
    }
}

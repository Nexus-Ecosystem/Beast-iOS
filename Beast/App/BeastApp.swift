import SwiftUI
import NexusDesignSystem
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
struct BeastApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate

    init() {
        configureFirebase()
    }

    var body: some Scene {
        WindowGroup {
            NexusAppRoot(
                app: .nexus,
                showsSplash: true,
                isReady: true,
                splashMinimumDuration: 1.5
            ) {
                RootView()
            }
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
            fatalError(
                "No se encontró la configuración de Firebase"
            )
        }

        FirebaseApp.configure(options: options)
    }
}

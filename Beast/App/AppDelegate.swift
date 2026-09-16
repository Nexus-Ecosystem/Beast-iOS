import UIKit
import FirebaseMessaging
import UserNotifications

final class AppDelegate: NSObject,
    UIApplicationDelegate,
    UNUserNotificationCenterDelegate,
    MessagingDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self

        Task {
            do {
                let granted = try await
                    UNUserNotificationCenter.current()
                    .requestAuthorization(
                        options: [.alert, .badge, .sound]
                    )

                if granted {
                    await MainActor.run {
                        UIApplication.shared
                            .registerForRemoteNotifications()
                    }
                }
            } catch {
                print("❌ Push permission:", error)
            }
        }

        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken
            deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken

        print(
            "🍎 APNs:",
            deviceToken.map {
                String(format: "%02.2hhx", $0)
            }.joined()
        )
    }

    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        guard let fcmToken else { return }

        print("🔥 FCM TOKEN:")
        print(fcmToken)

        // Aquí después lo mandamos a tu backend.
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .badge]
    }
}

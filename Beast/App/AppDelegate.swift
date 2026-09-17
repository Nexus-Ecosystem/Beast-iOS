import UIKit
import FirebaseCore
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

        print("🚀 APP DELEGATE INICIADO")
        print("🔥 Firebase app:", FirebaseApp.app()?.name ?? "NIL")
        print(
            "🔥 Firebase project:",
            FirebaseApp.app()?.options.projectID ?? "NIL"
        )

        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self

        configureNotifications(application)

        return true
    }

    // MARK: - Notifications

    private func configureNotifications(
        _ application: UIApplication
    ) {
        Task {
            do {
                let settings = await UNUserNotificationCenter.current()
                    .notificationSettings()

                print(
                    "🔔 Estado inicial:",
                    settings.authorizationStatus.rawValue
                )

                let granted = try await UNUserNotificationCenter.current()
                    .requestAuthorization(
                        options: [.alert, .badge, .sound]
                    )

                print("🔔 Permiso push:", granted)

                guard granted else {
                    print("⚠️ Usuario no autorizó notificaciones")
                    return
                }

                await MainActor.run {
                    print("📲 Registrando con APNs...")
                    application.registerForRemoteNotifications()
                }

            } catch {
                print("❌ Error solicitando permiso push:")
                print(error)
            }
        }
    }

    // MARK: - APNs Success

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let apnsToken = deviceToken
            .map { String(format: "%02.2hhx", $0) }
            .joined()

        print("🍎 APNs TOKEN:")
        print(apnsToken)

        Messaging.messaging().apnsToken = deviceToken

        print("🔥 APNs token asignado a Firebase Messaging")

        requestFCMToken()
    }

    // MARK: - APNs Error

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("❌ ERROR REGISTRANDO APNs:")
        print(error)
    }

    // MARK: - FCM Delegate

    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        guard let fcmToken else {
            print("⚠️ Firebase devolvió FCM token NIL")
            return
        }

        print("🔥🔥🔥 FCM TOKEN DELEGATE:")
        print(fcmToken)

        saveFCMToken(fcmToken)
    }

    // MARK: - Force FCM Token

    private func requestFCMToken() {
        Messaging.messaging().token { [weak self] token, error in
            if let error {
                print("❌ ERROR OBTENIENDO FCM TOKEN:")
                print(error)
                return
            }

            guard let token else {
                print("⚠️ FCM TOKEN NIL")
                return
            }

            print("🔥🔥🔥 FCM TOKEN MANUAL:")
            print(token)

            Task { @MainActor in
                self?.saveFCMToken(token)
            }
        }
    }

    // MARK: - Save Token

    @MainActor
    private func saveFCMToken(
        _ token: String
    ) {
        print("💾 FCM listo para guardar:")
        print(token)

        /*
         IMPORTANTE:

         Aquí debes llamar al servicio que guarda
         el FCM token en tu backend/Firebase.

         Por ahora dejamos el print para comprobar
         todo el flujo.
         */
    }

    // MARK: - Foreground Notifications

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {

        print("📩 PUSH RECIBIDA EN FOREGROUND")

        if let userInfo =
            notification.request.content.userInfo
                as? [String: Any] {
            print("📦 Payload:", userInfo)
        }

        return [.banner, .sound, .badge]
    }

    // MARK: - Notification Tap

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        print("👆 PUSH ABIERTA")
        print(
            "📦 Payload:",
            response.notification.request.content.userInfo
        )
    }
}

import SwiftUI
import FirebaseCore

@main
struct BeastApp: App {
    
    init() {
         FirebaseApp.configure()
     }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

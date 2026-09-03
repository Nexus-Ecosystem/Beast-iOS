import SwiftUI

enum MainTab: Hashable, CaseIterable {
    case home
    case schedule
    case packages
    case profile

    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .schedule:
            return "calendar"
        case .packages:
            return "flame.fill"
        case .profile:
            return "person.fill"
        }
    }

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .schedule:
            return "Schedule"
        case .packages:
            return "Packages"
        case .profile:
            return "Profile"
        }
    }
}

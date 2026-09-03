import SwiftUI

enum BeastDialogStyle {
    case error
    case success
    case warning
    case info

    var icon: String {
        switch self {
        case .error:
            return "exclamationmark.triangle.fill"
        case .success:
            return "checkmark"
        case .warning:
            return "exclamationmark"
        case .info:
            return "info"
        }
    }

    var accentColor: Color {
        switch self {
        case .error:
            return Color.red
        case .success:
            return BeastColors.primary
        case .warning:
            return BeastColors.yellowPrimary
        case .info:
            return BeastColors.accent
        }
    }

    var titleColor: Color {
        switch self {
        case .error:
            return BeastColors.onboardingAccent
        case .success:
            return BeastColors.onboardingAccent
        case .warning:
            return BeastColors.onboardingAccent
        case .info:
            return .white
        }
    }

    var defaultTitle: String {
        switch self {
        case .error:
            return "¡Aviso!"
        case .success:
            return "¡Listo!"
        case .warning:
            return "¡Atención!"
        case .info:
            return "Información"
        }
    }
}

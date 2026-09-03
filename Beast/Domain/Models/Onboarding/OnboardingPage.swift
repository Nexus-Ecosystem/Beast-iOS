import Foundation

struct OnboardingPage: Identifiable, Equatable {
    let id: Int
    let imageName: String
    let step: String
    let title: String
    let highlightedTitle: String
    let description: String
    let buttonTitle: String
    let buttonIcon: String

    static let pages: [OnboardingPage] = [
        OnboardingPage(
            id: 0,
            imageName: "onboarding_01",
            step: "PASO 01 / 03",
            title: "DESCUBRE",
            highlightedTitle: "TU POTENCIAL",
            description: "Explora una variedad de rutinas de entrenamiento diseñadas para ayudarte a alcanzar tus metas de fitness y mejorar tu rendimiento. Empieza hoy mismo.",
            buttonTitle: "SIGUIENTE",
            buttonIcon: "arrow.right"
        ),
        OnboardingPage(
            id: 1,
            imageName: "onboarding_02",
            step: "PASO 02 / 03",
            title: "RESERVA",
            highlightedTitle: "TU ESPACIO",
            description: "Acceso exclusivo a las mejores clases de HIIT y Cycling. Sin esperas, sin complicaciones. Tu lugar te está esperando.",
            buttonTitle: "SIGUIENTE",
            buttonIcon: "arrow.right"
        ),
        OnboardingPage(
            id: 2,
            imageName: "onboarding_03",
            step: "PASO 03 / 03",
            title: "ÚNETE A",
            highlightedTitle: "LA ÉLITE",
            description: "Forma parte de la comunidad global de alto rendimiento. El momento de transformar tu potencial es ahora.",
            buttonTitle: "EMPEZAR AHORA",
            buttonIcon: "bolt.fill"
        )
    ]
}

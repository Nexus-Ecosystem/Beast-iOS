import SwiftUI

struct BeastAlertDialog: View {
    let style: BeastDialogStyle
    let title: String?
    let message: String
    let buttonTitle: String
    let action: () -> Void

    init(
        style: BeastDialogStyle = .error,
        title: String? = nil,
        message: String,
        buttonTitle: String = "Entendido",
        action: @escaping () -> Void
    ) {
        self.style = style
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.action = action
    }

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.72)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                topAccentLine

                VStack(spacing: 0) {
                    iconView
                        .padding(.top, 18)

                    Text(title ?? style.defaultTitle)
                        .font(.system(size: 18, weight: .black))
                        .italic()
                        .foregroundStyle(style.titleColor)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)

                    Text(message)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.white.opacity(0.72))
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                    Button {
                        action()
                    } label: {
                        Text(buttonTitle)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(style.accentColor)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 18)
                    .padding(.top, 20)
                    .padding(.bottom, 18)
                }
            }
            .frame(maxWidth: 250)
            .background(
                Color(red: 0.075, green: 0.075, blue: 0.085)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 18,
                    style: .continuous
                )
            )
            .overlay {
                RoundedRectangle(
                    cornerRadius: 18,
                    style: .continuous
                )
                .stroke(
                    Color.white.opacity(0.04),
                    lineWidth: 1
                )
            }
            .shadow(
                color: .black.opacity(0.50),
                radius: 18,
                x: 0,
                y: 10
            )
        }
    }

    private var topAccentLine: some View {
        LinearGradient(
            stops: [
                .init(
                    color: Color(red: 0.90, green: 0.20, blue: 0.20),
                    location: 0.00
                ),
                .init(
                    color: Color(red: 0.55, green: 0.25, blue: 0.30),
                    location: 0.30
                ),
                .init(
                    color: Color(red: 0.18, green: 0.35, blue: 0.42),
                    location: 0.65
                ),
                .init(
                    color: Color(red: 0.15, green: 0.82, blue: 0.78),
                    location: 1.00
                )
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(maxWidth: .infinity)
        .frame(height: 1)
    }
    
    private var iconView: some View {
        ZStack {
            Circle()
                .fill(style.accentColor)
                .frame(width: 44, height: 44)

            Image(systemName: style.icon)
                .font(.system(size: 19, weight: .black))
                .foregroundStyle(.black)
        }
    }
}

#Preview("Error") {
    BeastAlertDialog(
        style: .error,
        message: "Alguno de tus datos es incorrecto\nInténtalo de nuevo!"
    ) {}
}

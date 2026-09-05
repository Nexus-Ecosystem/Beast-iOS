import SwiftUI

struct BeastLogoutDialog: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void

    private let cardColor = Color(
        red: 0.13,
        green: 0.14,
        blue: 0.16
    )

    private let buttonDark = Color(
        red: 0.075,
        green: 0.075,
        blue: 0.085
    )

    private let yellow = Color(
        red: 1.0,
        green: 0.83,
        blue: 0.20
    )

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.78)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(yellow)
                        .frame(
                            width: 64,
                            height: 64
                        )

                    Image(
                        systemName: "power"
                    )
                    .font(
                        .system(
                            size: 30,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.black)
                }

                Text("¿CERRAR\nSESIÓN?")
                    .font(
                        .system(
                            size: 25,
                            weight: .black
                        )
                    )
                    .italic()
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(0)
                    .padding(.top, 14)

                Text(
                    "¿Estás seguro de que quieres\nsalir? Tendrás que volver a\ningresar tus credenciales."
                )
                .font(
                    .system(
                        size: 11,
                        weight: .regular
                    )
                )
                .foregroundStyle(
                    .white.opacity(0.72)
                )
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .padding(.top, 14)

                Button {
                    onConfirm()
                } label: {
                    Text("CERRAR SESIÓN")
                        .font(
                            .system(
                                size: 11,
                                weight: .black
                            )
                        )
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(
                            Capsule()
                                .fill(yellow)
                        )
                }
                .buttonStyle(.plain)
                .padding(.top, 22)

                Button {
                    onCancel()
                } label: {
                    Text("CANCELAR")
                        .font(
                            .system(
                                size: 10,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(
                            Capsule()
                                .fill(buttonDark)
                        )
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
            }
            .padding(
                .horizontal,
                24
            )
            .padding(
                .top,
                24
            )
            .padding(
                .bottom,
                24
            )
            .frame(width: 222)
            .background(
                RoundedRectangle(
                    cornerRadius: 24,
                    style: .continuous
                )
                .fill(cardColor)
            )
            .shadow(
                color: .black.opacity(0.45),
                radius: 20,
                x: 0,
                y: 12
            )
        }
        .transition(.opacity)
    }
}

#Preview {
    BeastLogoutDialog(
        onConfirm: {},
        onCancel: {}
    )
}

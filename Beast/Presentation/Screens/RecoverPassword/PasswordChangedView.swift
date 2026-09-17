import SwiftUI

struct PasswordChangedView: View {

    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 22) {
            Spacer()

            ZStack {
                Circle()
                    .fill(
                        Color("BeastTabSelected")
                            .opacity(0.12)
                    )
                    .frame(
                        width: 100,
                        height: 100
                    )

                Image(
                    systemName:
                        "checkmark.circle.fill"
                )
                .font(
                    .system(size: 52)
                )
                .foregroundStyle(
                    Color("BeastTabSelected")
                )
            }

            Text("¡LISTO!")
                .font(
                    .system(
                        size: 34,
                        weight: .black
                    )
                )
                .italic()

            Text(
                """
                Cambiaste tu contraseña correctamente. Ahora puedes ingresar con tu nueva contraseña.
                """
            )
            .font(
                .system(
                    size: 14,
                    weight: .medium
                )
            )
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .lineSpacing(3)
            .padding(.horizontal, 30)

            Spacer()

            Button {
                onContinue()
            } label: {
                Text("INICIAR SESIÓN")
                    .font(
                        .system(
                            size: 14,
                            weight: .black
                        )
                    )
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(
                        Color("BeastTabSelected")
                    )
                    .clipShape(Capsule())
            }
        }
        .padding(24)
        .padding(.bottom, 20)
        .background(
            Color("BeastBackground")
                .ignoresSafeArea()
        )
    }
}

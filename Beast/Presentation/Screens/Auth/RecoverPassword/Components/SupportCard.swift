import SwiftUI

struct SupportCard: View {
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color("BeastSurface"))
                        .frame(width: 32, height: 32)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color("BeastBorder"), lineWidth: 1)
                        )

                    Image(systemName: "questionmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color("BeastTextSecondary"))
                }

                Text("¿Ya no tienes acceso?")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color("BeastTextPrimary"))
            }

            Text("Si perdiste acceso a tu correo o teléfono, contacta a nuestro equipo de soporte para verificación manual.")
                .font(.caption)
                .foregroundStyle(Color("BeastTextSecondary"))
                .fixedSize(horizontal: false, vertical: true)

            Button(action: onTap) {
                HStack(spacing: 6) {
                    Text("Contactar Soporte")
                        .font(.footnote.weight(.bold))
                    Image(systemName: "arrow.right")
                        .font(.footnote.weight(.bold))
                }
                .foregroundStyle(Color("BeastYellowPrimary"))
            }
            .padding(.top, 2)
        }
    }
}

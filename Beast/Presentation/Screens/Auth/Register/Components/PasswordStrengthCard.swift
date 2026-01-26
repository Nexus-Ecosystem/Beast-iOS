import SwiftUI

struct PasswordStrengthCard: View {
    let strength: PasswordStrength

    private var progress: CGFloat {
        CGFloat(strength.score) / 4.0
    }

    private var barColor: Color {
        switch strength.score {
        case 0, 1: return Color.red
        case 2: return Color.yellow
        default:  return Color.green
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("SEGURIDAD DE LA CONTRASEÑA")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color("BeastTextSecondary"))

                Spacer()

                Text("\(strength.score)/4")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color("BeastTextSecondary"))
            }

            // Progress bar (animada)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color("BeastBorder").opacity(0.35))
                        .frame(height: 8)

                    Capsule()
                        .fill(barColor)
                        .frame(width: max(8, geo.size.width * progress), height: 8)
                        .animation(.easeOut(duration: 0.18), value: strength.score)
                }
            }
            .frame(height: 8)

            // Rules (2 columnas)
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    RuleRow(isOn: strength.hasUppercase, text: "1 Mayúscula")
                    RuleRow(isOn: strength.hasSpecial, text: "1 Carácter especial")
                }

                VStack(alignment: .leading, spacing: 8) {
                    RuleRow(isOn: strength.hasNumber, text: "1 Número")
                    RuleRow(isOn: strength.hasMinLength, text: "8+ Caracteres")
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color("BeastSurface"))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color("BeastBorder"), lineWidth: 1)
                )
        )
    }
}

private struct RuleRow: View {
    let isOn: Bool
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color("BeastSurface"))
                    .frame(width: 18, height: 18)
                    .overlay(Circle().stroke(Color("BeastBorder"), lineWidth: 1))

                Image(systemName: isOn ? "checkmark" : "circle")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(isOn ? Color.green : Color("BeastTextSecondary"))
            }

            Text(text)
                .font(.caption)
                .foregroundStyle(Color("BeastTextSecondary"))
        }
    }
}

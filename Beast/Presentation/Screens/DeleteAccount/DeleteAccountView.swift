import SwiftUI

struct DeleteAccountView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: DeleteAccountViewModel

    let onAccountDeleted: () -> Void

    init(
        email: String,
        onAccountDeleted: @escaping () -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: DeleteAccountViewModel(email: email)
        )

        self.onAccountDeleted = onAccountDeleted
    }

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 26) {
                    heroSection
                    affectedDataSection
                    warningSection
                    confirmationSection
                    actionSection

                    Spacer()
                        .frame(height: 24)
                }
                .padding(.horizontal, 22)
                .padding(.top, 18)
                .padding(.bottom, 36)
            }

            if viewModel.isLoading {
                BeastLoadingOverlay(
                    message: "Eliminando cuenta..."
                )
                .zIndex(1000)
            }

            if viewModel.showError {
                BeastAlertDialog(
                    style: .error,
                    title: "¡Atención!",
                    message: viewModel.errorMessage,
                    buttonTitle: "Entendido"
                ) {
                    viewModel.closeError()
                }
                .zIndex(2000)
            }
        }
        .navigationTitle("Eliminar cuenta")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }

    private var heroSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(BeastColors.danger.opacity(0.10))
                    .frame(width: 78, height: 78)

                Circle()
                    .stroke(
                        BeastColors.danger.opacity(0.20),
                        lineWidth: 1
                    )
                    .frame(width: 78, height: 78)

                Image(systemName: "exclamationmark.shield.fill")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(BeastColors.danger)
            }

            VStack(spacing: 7) {
                Text("ELIMINAR TU CUENTA")
                    .font(.system(size: 25, weight: .black))
                    .italic()
                    .foregroundStyle(BeastColors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(
                    "Esta acción es permanente y eliminará la información asociada a tu cuenta."
                )
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(BeastColors.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
                .padding(.horizontal, 12)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var affectedDataSection: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            Text("SE ELIMINARÁ")
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(BeastColors.textSecondary)
                .padding(.leading, 2)

            VStack(spacing: 0) {
                affectedRow(
                    icon: "person.fill",
                    title: "Perfil y datos personales"
                )

                rowDivider

                affectedRow(
                    icon: "calendar",
                    title: "Reservas e historial"
                )

                rowDivider

                affectedRow(
                    icon: "creditcard.fill",
                    title: "Membresías y paquetes"
                )

                rowDivider

                affectedRow(
                    icon: "figure.indoor.cycle",
                    title: "Actividad y progreso"
                )
            }
        }
    }

    private var warningSection: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            HStack(spacing: 9) {
                Image(
                    systemName: "exclamationmark.circle.fill"
                )
                .font(.system(size: 17, weight: .bold))

                Text("Esta acción no se puede deshacer")
                    .font(.system(size: 14, weight: .black))
            }

            warningRow(
                "Perderás permanentemente el acceso a tu cuenta."
            )

            warningRow(
                "Tus reservas, historial y progreso dejarán de estar disponibles."
            )

            warningRow(
                "La información eliminada no podrá recuperarse."
            )
        }
        .foregroundStyle(BeastColors.danger)
        .padding(16)
        .background(
            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
            .fill(BeastColors.danger.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
            .stroke(
                BeastColors.danger.opacity(0.18),
                lineWidth: 1
            )
        )
    }

    private var confirmationSection: some View {
        VStack(
            alignment: .leading,
            spacing: 18
        ) {
            VStack(
                alignment: .leading,
                spacing: 10
            ) {
                Text("ESCRIBE “ELIMINAR” PARA CONFIRMAR")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(BeastColors.textSecondary)

                TextField(
                    "ELIMINAR",
                    text: $viewModel.confirmationText
                )
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(BeastColors.textPrimary)
                .padding(.horizontal, 16)
                .frame(height: 52)
                .background(
                    RoundedRectangle(
                        cornerRadius: 16,
                        style: .continuous
                    )
                    .fill(BeastColors.surface)
                )
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 16,
                        style: .continuous
                    )
                    .stroke(
                        viewModel.isConfirmationValid
                        ? BeastColors.danger.opacity(0.55)
                        : BeastColors.border,
                        lineWidth: 1
                    )
                )
            }

            acknowledgementRow
        }
    }

    private var acknowledgementRow: some View {
        Button {
            viewModel.hasAcceptedConsequences.toggle()
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(
                        cornerRadius: 6,
                        style: .continuous
                    )
                    .fill(
                        viewModel.hasAcceptedConsequences
                        ? BeastColors.danger
                        : Color.clear
                    )
                    .frame(width: 23, height: 23)

                    RoundedRectangle(
                        cornerRadius: 6,
                        style: .continuous
                    )
                    .stroke(
                        viewModel.hasAcceptedConsequences
                        ? BeastColors.danger
                        : BeastColors.border,
                        lineWidth: 1.5
                    )
                    .frame(width: 23, height: 23)

                    if viewModel.hasAcceptedConsequences {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .black))
                            .foregroundStyle(.white)
                    }
                }

                Text(
                    "Entiendo que perderé permanentemente mi información."
                )
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(BeastColors.textPrimary)
                .multilineTextAlignment(.leading)

                Spacer(minLength: 0)
            }
        }
        .buttonStyle(.plain)
    }

    private var actionSection: some View {
        VStack(spacing: 10) {
            Button {
                Task {
                    await viewModel.deleteAccount {
                        onAccountDeleted()
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 13, weight: .bold))

                    Text("ELIMINAR CUENTA")
                        .font(.system(size: 12, weight: .black))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    Capsule()
                        .fill(
                            BeastColors.danger.opacity(
                                viewModel.canDelete ? 1 : 0.20
                            )
                        )
                )
            }
            .buttonStyle(.plain)
            .disabled(!viewModel.canDelete)

            Button {
                dismiss()
            } label: {
                Text("Cancelar")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(BeastColors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
            }
            .buttonStyle(.plain)
        }
    }

    private var rowDivider: some View {
        Divider()
            .padding(.leading, 46)
    }

    private func affectedRow(
        icon: String,
        title: String
    ) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(BeastColors.textSecondary)
                .frame(width: 20)

            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(BeastColors.textPrimary)

            Spacer()
        }
        .frame(height: 46)
    }

    private func warningRow(
        _ text: String
    ) -> some View {
        HStack(
            alignment: .top,
            spacing: 8
        ) {
            Circle()
                .fill(BeastColors.danger)
                .frame(width: 4, height: 4)
                .padding(.top, 7)

            Text(text)
                .font(.system(size: 12, weight: .medium))
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        }
    }
}

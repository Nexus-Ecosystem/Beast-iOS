import SwiftUI

struct RecoverPasswordView: View {
    @StateObject private var viewModel = RecoverPasswordViewModel()
    @State private var showVerification = false

    @FocusState private var emailFocused: Bool

    let onCompleted: () -> Void

    init(
        onCompleted: @escaping () -> Void = {}
    ) {
        self.onCompleted = onCompleted
    }

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    securityIcon
                        .padding(.top, 28)

                    Text("SEGURIDAD")
                        .font(.system(size: 11, weight: .black))
                        .tracking(2)
                        .foregroundStyle(BeastColors.primary)
                        .padding(.top, 14)

                    Text("¿OLVIDASTE TU\nACCESO?")
                        .font(.system(size: 31, weight: .black))
                        .italic()
                        .multilineTextAlignment(.center)
                        .foregroundStyle(BeastColors.textPrimary)
                        .padding(.top, 6)

                    Text(
                        "No te detengas. Ingresa tu correo electrónico para recibir un código de recuperación instantáneo."
                    )
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(BeastColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 22)
                    .padding(.top, 20)

                    emailSection
                        .padding(.top, 36)

                    sendButton
                        .padding(.top, 28)

                    Spacer()
                        .frame(height: 60)

                    securityCards
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
            .scrollDismissesKeyboard(.interactively)

            overlays
        }
        .navigationTitle("Recuperar contraseña")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .navigationDestination(isPresented: $showVerification) {
            VerificationView(
                user: recoveryUser,
                mode: .passwordRecovery,
                onPasswordRecoveryCompleted: onCompleted
            )
        }
        .onChange(of: viewModel.step) { _, step in
            guard step == .otp else { return }
            showVerification = true
        }
    }

    // MARK: - Security Icon

    private var securityIcon: some View {
        ZStack {
            Circle()
                .stroke(
                    BeastColors.primary,
                    lineWidth: 2
                )
                .frame(width: 100, height: 100)

            Image(systemName: "lock.rotation")
                .font(.system(size: 38, weight: .bold))
                .foregroundStyle(BeastColors.primary)
        }
    }

    // MARK: - Email

    private var emailSection: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("CORREO REGISTRADO")
                .font(.system(size: 11, weight: .black))
                .tracking(1.5)
                .foregroundStyle(BeastColors.primary)

            HStack(spacing: 12) {
                Text("@")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(BeastColors.textSecondary)

                TextField(
                    "nombre@gmail.com",
                    text: $viewModel.email
                )
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .focused($emailFocused)
                .submitLabel(.continue)
                .onSubmit {
                    submit()
                }
            }
            .padding(.horizontal, 18)
            .frame(height: 58)
            .background(BeastColors.surface)
            .clipShape(Capsule())
        }
    }

    // MARK: - Send Button

    private var sendButton: some View {
        Button {
            submit()
        } label: {
            HStack(spacing: 10) {
                Text("ENVIAR CÓDIGO")

                Image(systemName: "arrow.right")
            }
            .font(.system(size: 14, weight: .black))
            .foregroundStyle(BeastColors.buttonText)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(
                Capsule()
                    .fill(
                        BeastColors.primary.opacity(
                            viewModel.isEmailValid ? 1 : 0.30
                        )
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(
            !viewModel.isEmailValid ||
            viewModel.isLoading
        )
    }

    // MARK: - Security Cards

    private var securityCards: some View {
        HStack(spacing: 14) {
            securityCard(
                icon: "checkmark.shield.fill",
                title: "ENCRIPTACIÓN DE\nGRADO ATLÉTICO"
            )

            securityCard(
                icon: "clock.arrow.circlepath",
                title: "RECUPERACIÓN EN\n30 SEGUNDOS"
            )
        }
    }

    private func securityCard(
        icon: String,
        title: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(BeastColors.primary)

            Text(title)
                .font(.system(size: 9, weight: .black))
                .foregroundStyle(BeastColors.textPrimary)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(16)
        .frame(height: 110)
        .background(BeastColors.surface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
        )
    }

    // MARK: - Overlays

    @ViewBuilder
    private var overlays: some View {
        if viewModel.isLoading {
            BeastLoadingOverlay()
                .zIndex(20)
        }

        if let error = viewModel.errorMessage {
            BeastAlertDialog(
                style: .error,
                title: "¡Aviso!",
                message: error,
                buttonTitle: "Entendido"
            ) {
                viewModel.resetError()
            }
            .zIndex(30)
        }
    }

    // MARK: - Recovery User

    private var recoveryUser: RegistrationUser {
        RegistrationUser(
            email: normalizedEmail,
            password: "",
            fullName: "",
            phone: ""
        )
    }

    private var normalizedEmail: String {
        viewModel.email
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .lowercased()
    }

    // MARK: - Actions

    private func submit() {
        guard
            viewModel.isEmailValid,
            !viewModel.isLoading
        else {
            return
        }

        emailFocused = false
        hideKeyboard()

        Task {
            await viewModel.sendOTP()
        }
    }
}

#Preview {
    NavigationStack {
        RecoverPasswordView()
    }
}

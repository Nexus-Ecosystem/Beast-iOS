import SwiftUI

struct VerificationView: View {
    @StateObject
    private var viewModel: VerificationViewModel

    @State
    private var showChangePassword = false

    @State
    private var showFindBranch = false

    init(
        user: RegistrationUser,
        mode: VerificationMode
    ) {
        _viewModel = StateObject(
            wrappedValue: VerificationViewModel(
                user: user,
                mode: mode
            )
        )
    }

    var body: some View {
        ZStack {
            BeastColors.background
                .ignoresSafeArea()

            ScrollView(
                showsIndicators: false
            ) {
                VStack(
                    alignment: .leading,
                    spacing: 0
                ) {
                    VerificationShieldView()
                        .frame(
                            maxWidth: .infinity
                        )
                        .padding(
                            .top,
                            18
                        )

                    Text(
                        "SEGURIDAD ACTIVADA"
                    )
                    .font(
                        .system(
                            size: 10,
                            weight: .black
                        )
                    )
                    .tracking(1)
                    .foregroundStyle(
                        BeastColors.primary
                    )
                    .padding(
                        .top,
                        22
                    )

                    VStack(
                        alignment: .leading,
                        spacing: 0
                    ) {
                        Text(
                            "¿RECIBISTE EL"
                        )
                        .foregroundStyle(
                            BeastColors.textPrimary
                        )

                        Text(
                            "CÓDIGO?"
                        )
                        .foregroundStyle(
                            BeastColors.primary
                        )
                    }
                    .font(
                        .system(
                            size: 32,
                            weight: .black
                        )
                    )
                    .italic()
                    .padding(
                        .top,
                        6
                    )

                    Text(
                        "Ingresa el código de 6 dígitos que enviamos a tu correo electrónico."
                    )
                    .font(
                        .system(
                            size: 13
                        )
                    )
                    .foregroundStyle(
                        BeastColors.textSecondary
                    )
                    .padding(
                        .top,
                        12
                    )

                    OTPInputView(
                        otp: $viewModel.otp
                    ) { value in
                        viewModel.updateOtp(
                            value
                        )
                    }
                    .padding(
                        .top,
                        30
                    )

                    verifyButton
                        .padding(
                            .top,
                            28
                        )

                    resendButton
                        .padding(
                            .top,
                            22
                        )

                    SecurityNoteCard()
                        .padding(
                            .top,
                            38
                        )

                    Spacer()
                        .frame(
                            height: 30
                        )
                }
                .padding(
                    .horizontal,
                    24
                )
            }

            if viewModel.isLoading {
                BeastLoadingOverlay()
                    .zIndex(20)
            }

            if viewModel.showError {
                BeastAlertDialog(
                    style: .error,
                    title: "¡Aviso!",
                    message: viewModel.errorMessage,
                    buttonTitle: "Entendido"
                ) {
                    viewModel.closeError()
                }
                .zIndex(30)
            }

            if viewModel.showSuccess {
                BeastAlertDialog(
                    style: .success,
                    title: "¡Felicidades!",
                    message: "Se ha creado tu cuenta exitosamente, ahora debes escoger tu STUDIO.",
                    buttonTitle: "Entendido"
                ) {
                    viewModel.showSuccess = false
                    showFindBranch = true
                }
                .zIndex(40)
            }
        }
        .navigationTitle(
            "Verificación"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
        .navigationDestination(
            isPresented: $showChangePassword
        ) {
            ChangePasswordView(
                email: viewModel.user.email
            )
        }
        .navigationDestination(
            isPresented: $showFindBranch
        ) {
            FindBranchView(
                email: viewModel.user.email
            ) {
                NotificationCenter.default.post(
                    name: .sessionDidChange,
                    object: nil
                )
            }
        }
        .onChange(
            of: viewModel.passwordOtpVerified
        ) { _, verified in
            guard verified else {
                return
            }

            showChangePassword = true
        }
        .toolbar(
            .hidden,
            for: .tabBar
        )
    }

    private var verifyButton: some View {
        Button {
            Task {
                await viewModel.verify()
            }
        } label: {
            HStack(
                spacing: 8
            ) {
                Text(
                    "VERIFICAR"
                )
                .font(
                    .system(
                        size: 13,
                        weight: .black
                    )
                )
                .italic()

                Image(
                    systemName: "bolt.fill"
                )
            }
            .foregroundStyle(
                BeastColors.buttonText
            )
            .frame(
                maxWidth: .infinity
            )
            .frame(
                height: 56
            )
            .background(
                Capsule()
                    .fill(
                        BeastColors.primary.opacity(
                            viewModel.isOtpComplete
                                ? 1
                                : 0.30
                        )
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(
            !viewModel.isOtpComplete
        )
    }

    private var resendButton: some View {
        HStack(
            spacing: 4
        ) {
            Text(
                "¿NO RECIBISTE EL CÓDIGO?"
            )
            .foregroundStyle(
                BeastColors.textSecondary
            )

            Button {
                Task {
                    await viewModel.resendOtp()
                }
            } label: {
                Text(
                    "Reenviar ahora"
                )
                .foregroundStyle(
                    BeastColors.primary
                )
                .fontWeight(
                    .bold
                )
            }
            .buttonStyle(.plain)
        }
        .font(
            .system(
                size: 10,
                weight: .bold
            )
        )
        .frame(
            maxWidth: .infinity
        )
    }
}

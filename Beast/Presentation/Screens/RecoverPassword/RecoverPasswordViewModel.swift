import Foundation
import Combine

@MainActor
final class RecoverPasswordViewModel:
    ObservableObject
{
    enum Step:
        Equatable
    {
        case email
        case otp
        case newPassword
        case completed
    }

    @Published var email = ""
    @Published var otp = ""

    @Published var password = ""
    @Published var confirmPassword = ""

    @Published private(set)
    var step: Step = .email

    @Published private(set)
    var isLoading = false

    @Published
    var errorMessage: String?

    private let sendOTPUseCase:
        SendOTPUseCase

    private let verifyOTPUseCase:
        VerifyOTPUseCase

    private let changePasswordUseCase:
        ChangePasswordUseCase

    init(
        sendOTPUseCase:
            SendOTPUseCase =
                SendOTPUseCase(),

        verifyOTPUseCase:
            VerifyOTPUseCase =
                VerifyOTPUseCase(),

        changePasswordUseCase:
            ChangePasswordUseCase =
                ChangePasswordUseCase()
    ) {
        self.sendOTPUseCase =
            sendOTPUseCase

        self.verifyOTPUseCase =
            verifyOTPUseCase

        self.changePasswordUseCase =
            changePasswordUseCase
    }

    // MARK: - Email

    var isEmailValid: Bool {
        let value =
            email
                .trimmingCharacters(
                    in:
                        .whitespacesAndNewlines
                )

        guard !value.isEmpty else {
            return false
        }

        let pattern =
            #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

        return value.range(
            of: pattern,
            options:
                .regularExpression
        ) != nil
    }

    // MARK: - OTP

    var isOTPValid: Bool {
        !otp
            .trimmingCharacters(
                in:
                    .whitespacesAndNewlines
            )
            .isEmpty
    }

    // MARK: - Password

    var hasMinLength: Bool {
        password.count >= 8
    }

    var hasUppercase: Bool {
        password.contains {
            $0.isUppercase
        }
    }

    var hasNumber: Bool {
        password.contains {
            $0.isNumber
        }
    }

    var hasSpecialCharacter: Bool {
        password.contains {
            !$0.isLetter &&
            !$0.isNumber
        }
    }

    var passwordStrength: Double {
        let rules = [
            hasMinLength,
            hasUppercase,
            hasNumber,
            hasSpecialCharacter
        ]

        let completed =
            rules.filter { $0 }.count

        return Double(completed) /
            Double(rules.count)
    }

    var passwordsMatch: Bool {
        !password.isEmpty &&
        password ==
            confirmPassword
    }

    var canChangePassword: Bool {
        hasMinLength &&
        hasUppercase &&
        hasNumber &&
        hasSpecialCharacter &&
        passwordsMatch
    }

    // MARK: - Send OTP

    func sendOTP() async {
        guard isEmailValid else {
            errorMessage =
                "Ingresa un correo electrónico válido."
            return
        }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let cleanEmail =
                email
                    .trimmingCharacters(
                        in:
                            .whitespacesAndNewlines
                    )

            try await sendOTPUseCase
                .execute(
                    email: cleanEmail
                )

            step = .otp

        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    // MARK: - Verify OTP

    func verifyOTP() async {
        guard isOTPValid else {
            errorMessage =
                "Ingresa el código de verificación."
            return
        }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let cleanEmail =
                email
                    .trimmingCharacters(
                        in:
                            .whitespacesAndNewlines
                    )

            let cleanOTP =
                otp
                    .trimmingCharacters(
                        in:
                            .whitespacesAndNewlines
                    )

            try await verifyOTPUseCase
                .execute(
                    email: cleanEmail,
                    otp: cleanOTP
                )

            step = .newPassword

        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    // MARK: - Change Password

    func changePassword() async {
        guard canChangePassword else {
            errorMessage =
                "La contraseña no cumple con todos los requisitos."
            return
        }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let cleanEmail =
                email
                    .trimmingCharacters(
                        in:
                            .whitespacesAndNewlines
                    )

            try await changePasswordUseCase
                .execute(
                    email: cleanEmail,
                    newPassword:
                        password
                )

            step = .completed

        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    // MARK: - Navigation

    func goBack() {
        switch step {
        case .email:
            break

        case .otp:
            otp = ""
            step = .email

        case .newPassword:
            password = ""
            confirmPassword = ""
            step = .otp

        case .completed:
            break
        }

        errorMessage = nil
    }

    // MARK: - Reset

    func resetError() {
        errorMessage = nil
    }

    func reset() {
        email = ""
        otp = ""
        password = ""
        confirmPassword = ""

        errorMessage = nil
        isLoading = false

        step = .email
    }
}

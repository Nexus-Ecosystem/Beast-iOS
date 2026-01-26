import Foundation

struct PasswordStrength {
    let password: String

    var hasUppercase: Bool { password.range(of: "[A-Z]", options: .regularExpression) != nil }
    var hasNumber: Bool { password.range(of: "[0-9]", options: .regularExpression) != nil }
    var hasSpecial: Bool { password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil }
    var hasMinLength: Bool { password.count >= 8 }

    var score: Int {
        [hasUppercase, hasNumber, hasSpecial, hasMinLength].filter { $0 }.count
    }
}

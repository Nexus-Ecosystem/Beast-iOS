import SwiftUI

struct OtpCodeInputView: View {

    @Binding var d1: String
    @Binding var d2: String
    @Binding var d3: String
    @Binding var d4: String

    enum Field: Hashable { case f1, f2, f3, f4 }
    @FocusState private var focus: Field?

    var body: some View {
        HStack(spacing: 12) {
            otpBox(text: $d1, field: .f1, next: .f2, prev: nil)
            otpBox(text: $d2, field: .f2, next: .f3, prev: .f1)
            otpBox(text: $d3, field: .f3, next: .f4, prev: .f2)
            otpBox(text: $d4, field: .f4, next: nil, prev: .f3)
        }
        .onAppear { focus = .f1 }
    }

    private func otpBox(text: Binding<String>, field: Field, next: Field?, prev: Field?) -> some View {
        TextField("", text: text)
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .multilineTextAlignment(.center)
            .focused($focus, equals: field)
            .frame(width: 52, height: 56)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color("BeastSurface"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(focus == field ? Color("BeastYellowPrimary") : Color("BeastBorder"), lineWidth: 1.2)
                    )
            )
            .foregroundStyle(Color("BeastTextPrimary"))
            .font(.title3.weight(.bold))
            .onChange(of: text.wrappedValue) { newValue in
                // solo 1 dígito
                let filtered = newValue.filter { $0.isNumber }
                if filtered.count > 1 { text.wrappedValue = String(filtered.suffix(1)) }
                else { text.wrappedValue = filtered }

                if text.wrappedValue.count == 1 {
                    if let next { focus = next } else { focus = nil }
                } else if text.wrappedValue.isEmpty {
                    if let prev { focus = prev }
                }
            }
    }
}

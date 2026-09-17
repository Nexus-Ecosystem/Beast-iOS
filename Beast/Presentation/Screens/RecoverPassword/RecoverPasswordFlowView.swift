import SwiftUI

struct RecoverPasswordFlowView: View {
    let onClose: () -> Void

    var body: some View {
        RecoverPasswordView()
            .onDisappear {
                onClose()
            }
    }
}

#Preview {
    NavigationStack {
        RecoverPasswordFlowView(
            onClose: {}
        )
    }
}

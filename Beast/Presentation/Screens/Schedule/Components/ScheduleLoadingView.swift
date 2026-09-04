import SwiftUI

struct ScheduleLoadingView: View {
    var body: some View {
        ZStack {
            Color.black
                .opacity(
                    0.12
                )
                .ignoresSafeArea()

            ProgressView()
                .controlSize(
                    .large
                )
        }
    }
}

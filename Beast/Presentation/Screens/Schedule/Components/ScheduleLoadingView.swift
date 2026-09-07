import SwiftUI

struct ScheduleLoadingView: View {
    var body: some View {
        ZStack {
            BeastColors.background
                .opacity(
                    0.70
                )
                .ignoresSafeArea()

            ProgressView()
                .controlSize(
                    .large
                )
                .tint(
                    BeastColors.primary
                )
        }
    }
}

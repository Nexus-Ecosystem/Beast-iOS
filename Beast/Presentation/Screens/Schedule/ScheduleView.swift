import SwiftUI

struct ScheduleView: View {

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()

                Text("Schedule")
                    .font(.largeTitle.bold())
            }
            .navigationTitle("Schedule")
        }
    }
}

import SwiftUI

struct HomeView: View {

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()

                Text("Home")
                    .font(.largeTitle.bold())
            }
            .navigationTitle("Home")
        }
    }
}

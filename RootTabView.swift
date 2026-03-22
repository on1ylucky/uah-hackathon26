import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                UnlockView()
            }
            .tabItem {
                Label("Unlock", systemImage: "lock.open.fill")
            }

            NavigationStack {
                StudySetsView()
            }
            .tabItem {
                Label("Study Sets", systemImage: "square.stack.3d.up.fill")
            }

            NavigationStack {
                StatsView()
            }
            .tabItem {
                Label("Stats", systemImage: "chart.bar.fill")
            }

            NavigationStack {
                MoreView()
            }
            .tabItem {
                Label("More", systemImage: "ellipsis.circle.fill")
            }
        }
        .tint(.green)
    }
}

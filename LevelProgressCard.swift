import SwiftUI

struct LevelProgressCard: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Level Progress")
                        .font(.headline)

                    Text("Level \(appState.level)")
                        .font(.title3.bold())
                }

                Spacer()

                Text("\(appState.xp) / \(appState.xpNeededForNextLevel) XP")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            ProgressView(value: appState.levelProgress)
                .tint(.green)
                .scaleEffect(x: 1, y: 1.8, anchor: .center)

            Text("\(appState.xpNeededForNextLevel - appState.xp) XP until Level \(appState.level + 1)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(18)
    }
}

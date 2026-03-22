import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var randomQuote: String = ""

    var dailyQuote: String {
        randomQuote
    }

    var totalQuestions: Int {
        appState.studySets.reduce(0) { $0 + $1.questions.count }
    }

    var questionOfTheDay: String {
        guard !DailyContent.questionsOfTheDay.isEmpty else {
            return "No question today."
        }

        let dayNumber = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return DailyContent.questionsOfTheDay[(dayNumber - 1) % DailyContent.questionsOfTheDay.count]
    }

    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.98, blue: 1.0)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    questionOfTheDaySection
                    statGrid
                    levelSection
                    quickSnapshotSection
                    lockedAppsSection
                }
                .padding()
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Home")
        .onAppear {
            randomQuote = DailyContent.quotes.randomElement() ?? "Keep going — you’ve got this."
        }
    }

    var headerSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("StudyLock")
                        .font(.system(size: 34, weight: .bold, design: .rounded))

                    Text("Build focus. Earn your screen time.")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.secondary)
                }

                Spacer()

            }

            Text("“\(dailyQuote)”")
                .font(.subheadline)
                .italic()
                .foregroundColor(.secondary)

            HStack(spacing: 10) {
                badge(text: "Lv. \(appState.level)", icon: "star.fill", color: .blue)
                badge(text: "\(appState.streak) day streak", icon: "flame.fill", color: .green)
            }
        }
        .padding()
        .background(cardStyle())
    }

    var questionOfTheDaySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Question of the Day")
                    .font(.title3.bold())

                Spacer()

                Text("Daily")
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.10))
                    .foregroundColor(.green)
                    .cornerRadius(10)
            }

            Text(questionOfTheDay)
                .font(.subheadline)
                .foregroundColor(.primary)

        }
        .padding()
        .background(cardStyle())
    }

    var statGrid: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                statCard(
                    title: "Time Bank",
                    value: "\(appState.timeBank) min",
                    icon: "timer",
                    color: .blue
                )

                statCard(
                    title: "XP",
                    value: "\(appState.xp)",
                    icon: "bolt.fill",
                    color: .green
                )
            }

            HStack(spacing: 12) {
                statCard(
                    title: "Streak",
                    value: "\(appState.streak) days",
                    icon: "flame.fill",
                    color: .orange
                )

                statCard(
                    title: "Level",
                    value: "Lv. \(appState.level)",
                    icon: "star.fill",
                    color: .blue
                )
            }
        }
    }

    var levelSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Level Progress")
                    .font(.title3.bold())

                Spacer()

                Text("\(appState.xp) / \(appState.xpNeededForNextLevel) XP")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
            }

            ProgressView(value: appState.levelProgress)
                .tint(.green)
                .scaleEffect(x: 1, y: 1.5, anchor: .center)

            Text("Keep answering questions to level up.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(cardStyle())
    }

    var quickSnapshotSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Snapshot")
                .font(.title3.bold())

            HStack {
                snapshotItem(title: "Study Sets", value: "\(appState.studySets.count)")
                Spacer()
                snapshotItem(title: "Questions", value: "\(totalQuestions)")
                Spacer()
                snapshotItem(
                    title: "Mode",
                    value: appState.questionMode == .multipleChoice ? "MCQ" : "Typed"
                )
            }
        }
        .padding()
        .background(cardStyle())
    }

    var lockedAppsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Locked Apps")
                .font(.title3.bold())

            if appState.lockedApps.isEmpty {
                VStack(spacing: 8) {
                    Text("No locked apps yet")
                        .font(.headline)

                    Text("Go to More to add an app and create your first lock rule.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(cardStyle())
            } else {
                ForEach(appState.lockedApps) { app in
                    let setName = appState.studySets.first(where: { $0.id == app.studySetID })?.title ?? "No study set"

                    HStack(spacing: 14) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.blue.opacity(0.10))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: app.icon)
                                    .foregroundColor(.blue)
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(app.name)
                                .font(.headline)

                            Text("\(app.requiredCorrect) \(app.requiredDifficulty.displayName.lowercased()) question(s)")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Text(setName)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Text(app.isDemoLinked ? "Linked" : "Demo")
                            .font(.caption.bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.10))
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    .background(cardStyle())
                }
            }
        }
    }

    func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .padding(10)
                .background(color.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.headline.bold())
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(cardStyle())
    }

    func snapshotItem(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.headline.bold())
        }
    }

    func badge(text: String, icon: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.caption.bold())
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(color.opacity(0.10))
        .foregroundColor(color)
        .cornerRadius(12)
    }

    func cardStyle() -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black.opacity(0.04), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
}

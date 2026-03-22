import SwiftUI

struct StatsView: View {
    @EnvironmentObject var appState: AppState

    var totalStudySets: Int {
        appState.studySets.count
    }

    var totalQuestions: Int {
        appState.studySets.reduce(0) { $0 + $1.questions.count }
    }

    var totalCompletedQuestions: Int {
        appState.studySets.reduce(0) { total, set in
            total + appState.progress(for: set.id).completedQuestionIDs.count
        }
    }

    var overallCompletionRate: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(totalCompletedQuestions) / Double(totalQuestions)
    }

    var totalCorrectAnswers: Int {
        appState.studySets.reduce(0) { total, set in
            total + appState.progress(for: set.id).correctAnswers
        }
    }

    var totalIncorrectAnswers: Int {
        appState.studySets.reduce(0) { total, set in
            total + appState.progress(for: set.id).incorrectAnswers
        }
    }

    var overallAccuracyRate: Double {
        let attempts = totalCorrectAnswers + totalIncorrectAnswers
        guard attempts > 0 else { return 0 }
        return Double(totalCorrectAnswers) / Double(attempts)
    }

    var totalRoundsCompleted: Int {
        appState.studySets.reduce(0) { total, set in
            total + appState.progress(for: set.id).roundsCompleted
        }
    }

    var totalXPFromStudySets: Int {
        appState.studySets.reduce(0) { total, set in
            total + appState.progress(for: set.id).xpEarned
        }
    }

    var totalTimeEarnedFromStudySets: Int {
        appState.studySets.reduce(0) { total, set in
            total + appState.progress(for: set.id).timeEarnedMinutes
        }
    }

    var mostPracticedSetName: String {
        let ranked = appState.studySets.map { set in
            (name: set.title, seen: appState.progress(for: set.id).seenQuestionIDs.count)
        }

        guard let best = ranked.max(by: { $0.seen < $1.seen }), best.seen > 0 else {
            return "None yet"
        }

        return best.name
    }

    var toughestSetName: String {
        let ranked = appState.studySets.map { set in
            (name: set.title, accuracy: appState.progress(for: set.id).accuracyRate, attempts: appState.progress(for: set.id).totalAttempts)
        }.filter { $0.attempts > 0 }

        guard let lowest = ranked.min(by: { $0.accuracy < $1.accuracy }) else {
            return "None yet"
        }

        return lowest.name
    }

    var bestSetName: String {
        let ranked = appState.studySets.map { set in
            (name: set.title, accuracy: appState.progress(for: set.id).accuracyRate, attempts: appState.progress(for: set.id).totalAttempts)
        }.filter { $0.attempts > 0 }

        guard let best = ranked.max(by: { $0.accuracy < $1.accuracy }) else {
            return "None yet"
        }

        return best.name
    }

    var highestBestStreak: Int {
        appState.studySets.map { appState.progress(for: $0.id).bestCorrectStreak }.max() ?? 0
    }

    var achievementBadges: [String] {
        var badges: [String] = []

        if totalRoundsCompleted >= 1 { badges.append("First Round ✅") }
        if totalRoundsCompleted >= 5 { badges.append("Consistency Champ 🔁") }
        if overallAccuracyRate >= 0.8 && (totalCorrectAnswers + totalIncorrectAnswers) >= 10 { badges.append("Sharp Mind 🎯") }
        if appState.level >= 3 { badges.append("Level Climber ⭐") }
        if totalCompletedQuestions >= 25 { badges.append("Flashcard Finisher 📚") }
        if highestBestStreak >= 10 { badges.append("Hot Streak 🔥") }

        return badges.isEmpty ? ["No badges yet — keep studying!"] : badges
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Your overall study performance and progress.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 12) {
                    Text("General Overview")
                        .font(.title2.bold())

                    HStack(spacing: 12) {
                        StatCircleCard(
                            title: "Accuracy",
                            valueText: "\(Int(overallAccuracyRate * 100))%",
                            subtitle: "overall",
                            progress: overallAccuracyRate,
                            color: .green
                        )

                        StatCircleCard(
                            title: "Completion",
                            valueText: "\(Int(overallCompletionRate * 100))%",
                            subtitle: "\(totalCompletedQuestions)/\(totalQuestions)",
                            progress: overallCompletionRate,
                            color: .blue
                        )
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("General Stats")
                        .font(.title2.bold())

                    Group {
                        statsRow(title: "Current Level", value: "Lv. \(appState.level)")
                        statsRow(title: "Current XP", value: "\(appState.xp)")
                        statsRow(title: "Time Bank", value: "\(appState.timeBank) min")
                        statsRow(title: "Current Streak", value: "\(appState.streak) days")
                        statsRow(title: "Rounds Completed", value: "\(totalRoundsCompleted)")
                        statsRow(title: "Total XP Earned From Study", value: "\(totalXPFromStudySets)")
                        statsRow(title: "Total Time Earned From Study", value: "\(totalTimeEarnedFromStudySets) min")
                        statsRow(title: "Most Practiced Set", value: mostPracticedSetName)
                        statsRow(title: "Best Accuracy Set", value: bestSetName)
                        statsRow(title: "Toughest Set", value: toughestSetName)
                        statsRow(title: "Best Study Streak", value: "\(highestBestStreak)")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(18)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Achievements")
                        .font(.title2.bold())

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(achievementBadges, id: \.self) { badge in
                            HStack {
                                Text(badge)
                                    .font(.subheadline.weight(.semibold))
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(14)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Study Set Stats")
                        .font(.title2.bold())

                    ForEach(appState.studySets) { set in
                        studySetCard(for: set)
                    }
                }
            }
            .padding()
            .padding(.bottom, 24)
        }
        .navigationTitle("Stats")
    }

    @ViewBuilder
    func statsRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 2)
    }

    @ViewBuilder
    func studySetCard(for set: StudySet) -> some View {
        let progress = appState.progress(for: set.id)
        let completionRate = appState.completionRate(for: set)
        let accuracyRate = progress.accuracyRate
        let mostMissed = appState.mostMissedDifficulty(for: set.id)

        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(set.title)
                        .font(.headline)
                    Text(set.subject)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text(appState.completionText(for: set))
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
            }

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Completion")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(Int(completionRate * 100))%")
                        .font(.headline)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("Accuracy")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(Int(accuracyRate * 100))%")
                        .font(.headline)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("Rounds")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(progress.roundsCompleted)")
                        .font(.headline)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                ProgressView(value: completionRate)
                    .tint(.blue)

                ProgressView(value: accuracyRate)
                    .tint(.green)
            }

            Group {
                statsMiniRow(title: "Seen", value: "\(progress.seenQuestionIDs.count)")
                statsMiniRow(title: "Best Streak", value: "\(progress.bestCorrectStreak)")
                statsMiniRow(title: "Most Missed Difficulty", value: mostMissed)
                statsMiniRow(title: "XP Earned", value: "\(progress.xpEarned)")
                statsMiniRow(title: "Time Earned", value: "\(progress.timeEarnedMinutes) min")
            }

            if let lastPracticed = progress.lastPracticedDate {
                Text("Last practiced: \(lastPracticed.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if let lastCompleted = progress.lastCompletedDate {
                Text("Last full completion: \(lastCompleted.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(18)
    }

    @ViewBuilder
    func statsMiniRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.caption.weight(.semibold))
        }
    }
}

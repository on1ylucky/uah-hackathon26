import SwiftUI

struct SimulationDemoView: View {
    @EnvironmentObject var appState: AppState

    @State private var selectedApp: LockedApp? = nil
    @State private var unlockedAppIDs: Set<UUID> = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "lock.iphone")
                    .font(.system(size: 56))
                    .foregroundColor(.green)

                VStack(spacing: 6) {
                    Text("Restricted App Demo")
                        .font(.largeTitle.bold())

                    Text("Tap an app to simulate the lock screen experience.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Apps")
                        .font(.title2.bold())

                    if appState.lockedApps.isEmpty {
                        Text("No locked apps added yet.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(appState.lockedApps) { app in
                            Button {
                                selectedApp = app
                            } label: {
                                HStack {
                                    Image(systemName: app.icon)
                                        .font(.title3)
                                        .frame(width: 28)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(app.name)
                                            .font(.headline)

                                        Text(simulationSubtitle(for: app))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    if unlockedAppIDs.contains(app.id) {
                                        Text("Unlocked")
                                            .font(.caption.weight(.semibold))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Color.green.opacity(0.15))
                                            .foregroundColor(.green)
                                            .cornerRadius(10)
                                    } else {
                                        Image(systemName: "lock.fill")
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(16)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
            .padding(.bottom, 24)
        }
        .navigationTitle("Simulation")
        .sheet(item: $selectedApp) { app in
            SimulationLockPopupView(
                app: app,
                studySet: appState.studySets.first(where: { $0.id == app.studySetID }),
                onUnlockComplete: {
                    unlockedAppIDs.insert(app.id)
                },
                onClose: {
                    selectedApp = nil
                }
            )
        }
    }

    func simulationSubtitle(for app: LockedApp) -> String {
        let setName = appState.studySets.first(where: { $0.id == app.studySetID })?.title ?? "No study set"
        return "\(app.requiredCorrect) \(app.requiredDifficulty.displayName.lowercased()) question(s) • \(setName)"
    }
}

struct SimulationLockPopupView: View {
    let app: LockedApp
    let studySet: StudySet?
    let onUnlockComplete: () -> Void
    let onClose: () -> Void

    @State private var currentQuestionIndex = 0
    @State private var correctCount = 0
    @State private var selectedChoice: String? = nil
    @State private var answerLocked = false
    @State private var showWrongMessage = false
    @State private var questionSet: [SimulationQuestion] = []
    @State private var showSuccessScreen = false

    var currentQuestion: SimulationQuestion? {
        guard !questionSet.isEmpty else { return nil }
        return questionSet[currentQuestionIndex % questionSet.count]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    if showSuccessScreen {
                        VStack(spacing: 16) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 64))
                                .foregroundColor(.green)

                            Text("Unlocked!")
                                .font(.largeTitle.bold())

                            Text("Great job — you completed the questions and can continue to \(app.name).")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)

                            Button("Continue to App") {
                                onClose()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: app.icon)
                                .font(.system(size: 42))
                                .foregroundColor(.green)

                            Text("\(app.name) is locked")
                                .font(.title2.bold())

                            Text(summaryText())
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                        }

                        if questionSet.isEmpty {
                            VStack(spacing: 10) {
                                Text("No usable questions found")
                                    .font(.headline)

                                Text("Choose a study set with at least one matching question for this difficulty.")
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(20)
                        } else if let currentQuestion {
                            VStack(alignment: .leading, spacing: 12) {
                                ProgressView(value: Double(correctCount), total: Double(max(app.requiredCorrect, 1)))
                                    .tint(.green)

                                Text("Progress: \(correctCount)/\(app.requiredCorrect)")
                                    .font(.subheadline.weight(.semibold))

                                Text(currentQuestion.prompt)
                                    .font(.headline)
                                    .padding(.top, 4)

                                ForEach(currentQuestion.choices, id: \.self) { choice in
                                    Button {
                                        handleAnswer(choice)
                                    } label: {
                                        Text(choice)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding()
                                            .background(choiceBackground(for: choice))
                                            .foregroundColor(choiceTextColor(for: choice))
                                            .cornerRadius(14)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .stroke(choiceBorder(for: choice), lineWidth: 1.5)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                    .disabled(answerLocked)
                                }

                                if showWrongMessage {
                                    Text("Not quite — keep going.")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(20)
                        }

                        Button("Close Demo") {
                            onClose()
                        }
                        .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .onAppear {
            if questionSet.isEmpty {
                questionSet = buildQuestionSet()
            }
        }
    }

    func summaryText() -> String {
        let setName = studySet?.title ?? "No study set selected"
        return "Answer \(app.requiredCorrect) \(app.requiredDifficulty.displayName.lowercased()) question(s) correctly from \(setName) to continue."
    }

    func buildQuestionSet() -> [SimulationQuestion] {
        guard let studySet else { return [] }

        let filtered: [StudyQuestion]
        switch app.requiredDifficulty {
        case .easy:
            filtered = studySet.questions.filter { $0.difficulty == .easy }
        case .medium:
            filtered = studySet.questions.filter { $0.difficulty == .medium }
        case .hard:
            filtered = studySet.questions.filter { $0.difficulty == .hard }
        case .mix:
            filtered = studySet.questions
        }

        return filtered.shuffled().map { question in
            SimulationQuestion(
                prompt: question.prompt,
                answer: question.answer,
                choices: question.choices.shuffled()
            )
        }
    }

    func handleAnswer(_ choice: String) {
        guard !answerLocked, let currentQuestion else { return }

        selectedChoice = choice
        answerLocked = true
        let isCorrect = choice == currentQuestion.answer

        if isCorrect {
            correctCount += 1
        } else {
            showWrongMessage = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            if correctCount >= app.requiredCorrect {
                onUnlockComplete()
                showSuccessScreen = true
                return
            }

            currentQuestionIndex += 1
            if currentQuestionIndex >= questionSet.count {
                currentQuestionIndex = 0
            }

            selectedChoice = nil
            answerLocked = false
            showWrongMessage = false
        }
    }

    func choiceBackground(for choice: String) -> Color {
        guard answerLocked, let selectedChoice, let currentQuestion else {
            return Color(.systemGray6)
        }

        if choice == currentQuestion.answer {
            return Color.green.opacity(0.2)
        }

        if choice == selectedChoice && selectedChoice != currentQuestion.answer {
            return Color.red.opacity(0.2)
        }

        return Color(.systemGray6)
    }

    func choiceTextColor(for choice: String) -> Color {
        guard answerLocked, let selectedChoice, let currentQuestion else {
            return .primary
        }

        if choice == currentQuestion.answer {
            return .green
        }

        if choice == selectedChoice && selectedChoice != currentQuestion.answer {
            return .red
        }

        return .primary
    }

    func choiceBorder(for choice: String) -> Color {
        guard answerLocked, let selectedChoice, let currentQuestion else {
            return .clear
        }

        if choice == currentQuestion.answer {
            return .green
        }

        if choice == selectedChoice && selectedChoice != currentQuestion.answer {
            return .red
        }

        return .clear
    }
}

struct SimulationQuestion {
    let prompt: String
    let answer: String
    let choices: [String]
}

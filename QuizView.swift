import SwiftUI

struct QuizView: View {
    @EnvironmentObject var appState: AppState

    let desiredMinutes: Int
    let selectedDifficulty: QuestionDifficulty
    let requiredCorrectAnswers: Int
    let studySet: StudySet

    @State private var questionPool: [StudyQuestion] = []
    @State private var currentQuestionIndex = 0
    @State private var correctAnswers = 0
    @State private var earnedMinutes = 0
    @State private var showFeedback = false
    @State private var isCorrect = false
    @State private var hasAwardedCompletionStreak = false
    @State private var shuffledChoices: [String] = []
    @State private var typedAnswer: String = ""
    @State private var roundWasReset = false
    @State private var hadAnyWrongAnswerThisRound = false

    @State private var xpPopupText: String? = nil
    @State private var showLevelUpPopup = false
    @State private var showPerfectRoundPopup = false

    @State private var selectedChoice: String? = nil
    @State private var answerLocked = false

    var currentQuestion: StudyQuestion? {
        guard !questionPool.isEmpty, currentQuestionIndex < questionPool.count else { return nil }
        return questionPool[currentQuestionIndex]
    }

    var progress: Double {
        guard requiredCorrectAnswers > 0 else { return 0 }
        return Double(correctAnswers) / Double(requiredCorrectAnswers)
    }

    var reward: Int {
        guard let currentQuestion else { return 0 }
        return selectedDifficulty == .mix
            ? currentQuestion.difficulty.rewardMinutes
            : selectedDifficulty.rewardMinutes
    }

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Text(studySet.title)
                    .font(.headline)
                    .foregroundColor(.secondary)

                if roundWasReset {
                    Text("You completed this set and started a new round.")
                        .font(.caption)
                        .foregroundColor(.orange)
                }

                ProgressView(value: progress)
                    .tint(.green)

                Text("Correct: \(correctAnswers)/\(requiredCorrectAnswers)")
                    .font(.headline)

                Text("Time Earned: \(earnedMinutes) min")
                    .font(.headline)
                    .foregroundColor(.green)

                if let currentQuestion {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(currentQuestion.prompt)
                            .font(.title3.bold())

                        if appState.questionMode == .multipleChoice {
                            ForEach(shuffledChoices, id: \.self) { choice in
                                Button {
                                    handleAnswer(choice)
                                } label: {
                                    Text(choice)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                        .background(choiceBackgroundColor(for: choice, correctAnswer: currentQuestion.answer))
                                        .foregroundColor(choiceTextColor(for: choice, correctAnswer: currentQuestion.answer))
                                        .cornerRadius(14)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(choiceBorderColor(for: choice, correctAnswer: currentQuestion.answer), lineWidth: 1.5)
                                        )
                                }
                                .buttonStyle(.plain)
                                .disabled(correctAnswers >= requiredCorrectAnswers || answerLocked)
                            }
                        } else {
                            VStack(spacing: 12) {
                                TextField("Type your answer", text: $typedAnswer)
                                    .textFieldStyle(.roundedBorder)
                                    .disabled(correctAnswers >= requiredCorrectAnswers || answerLocked)

                                Button {
                                    handleTypedAnswer()
                                } label: {
                                    Text("Submit Answer")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(14)
                                }
                                .disabled(
                                    typedAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                                    correctAnswers >= requiredCorrectAnswers ||
                                    answerLocked
                                )
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                } else {
                    VStack(spacing: 12) {
                        Text("No questions available")
                            .font(.title3.bold())
                        Text("Try another study set or difficulty.")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }

                if showFeedback, let currentQuestion {
                    VStack(spacing: 10) {
                        Text(isCorrect ? "Correct!" : "Incorrect")
                            .font(.title2.bold())
                            .foregroundColor(isCorrect ? .green : .red)

                        if isCorrect {
                            Text("+\(reward) minutes")
                                .foregroundColor(.green)
                        } else if appState.questionMode == .typedAnswer {
                            Text("Correct answer: \(currentQuestion.answer)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        if let explanation = currentQuestion.explanation {
                            Text(explanation)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                }

                if correctAnswers >= requiredCorrectAnswers {
                    VStack(spacing: 12) {
                        Text("Unlocked!")
                            .font(.largeTitle.bold())

                        Text("You earned \(earnedMinutes) minutes")
                            .font(.headline)

                        Text("Requested: \(desiredMinutes) minutes")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.green.opacity(0.15))
                    .cornerRadius(20)
                    .onAppear {
                        if !hasAwardedCompletionStreak {
                            appState.incrementStreak()
                            hasAwardedCompletionStreak = true

                            if !hadAnyWrongAnswerThisRound {
                                showTemporaryPerfectRoundPopup()
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Quiz")
            .onAppear {
                buildQuestionPool()
                shuffleChoices()
            }
            .onChange(of: currentQuestionIndex) { _, _ in
                shuffleChoices()
                typedAnswer = ""
                selectedChoice = nil
                answerLocked = false
            }

            if let xpPopupText {
                VStack {
                    Text(xpPopupText)
                        .font(.headline.bold())
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(Color.green.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .shadow(radius: 8)
                    Spacer()
                }
                .padding(.top, 20)
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            if showLevelUpPopup {
                popupCard(
                    title: "Level Up! ⭐",
                    subtitle: "Nice work — you reached Level \(appState.level).",
                    color: .yellow
                )
            }

            if showPerfectRoundPopup {
                popupCard(
                    title: "Perfect Round! 🎯",
                    subtitle: "You finished this round without any wrong answers.",
                    color: .blue
                )
            }
        }
    }

    @ViewBuilder
    func popupCard(title: String, subtitle: String, color: Color) -> some View {
        VStack {
            Spacer()

            VStack(spacing: 8) {
                Text(title)
                    .font(.title3.bold())

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: 280)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(color.opacity(0.35), lineWidth: 2)
            )
            .cornerRadius(18)
            .shadow(radius: 12)

            Spacer()
        }
        .padding()
        .transition(.scale.combined(with: .opacity))
    }

    func buildQuestionPool() {
        let filteredQuestions: [StudyQuestion]

        if selectedDifficulty == .mix {
            filteredQuestions = studySet.questions
        } else {
            let byDifficulty = studySet.questions.filter { $0.difficulty == selectedDifficulty }
            filteredQuestions = byDifficulty.isEmpty ? studySet.questions : byDifficulty
        }

        let progress = appState.progress(for: studySet.id)
        let uncompleted = filteredQuestions.filter { !progress.completedQuestionIDs.contains($0.id) }

        if uncompleted.isEmpty && !filteredQuestions.isEmpty {
            appState.markRoundCompleted(for: studySet.id)
            appState.resetRound(for: studySet.id)
            roundWasReset = true
            hadAnyWrongAnswerThisRound = false

            questionPool = appState.shuffleQuestions ? filteredQuestions.shuffled() : filteredQuestions
        } else {
            roundWasReset = false
            questionPool = appState.shuffleQuestions ? uncompleted.shuffled() : uncompleted
        }

        currentQuestionIndex = 0
    }

    func shuffleChoices() {
        guard let currentQuestion else {
            shuffledChoices = []
            return
        }

        shuffledChoices = currentQuestion.choices.shuffled()
    }

    func handleTypedAnswer() {
        guard let currentQuestion else { return }
        answerLocked = true

        let cleanedInput = typedAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedAnswer = currentQuestion.answer.trimmingCharacters(in: .whitespacesAndNewlines)

        let isMatch: Bool
        if appState.caseSensitiveAnswers {
            isMatch = cleanedInput == cleanedAnswer
        } else {
            isMatch = cleanedInput.lowercased() == cleanedAnswer.lowercased()
        }

        handleCheckedResult(isMatch)
    }

    func handleAnswer(_ choice: String) {
        guard let currentQuestion else { return }
        guard !answerLocked else { return }

        selectedChoice = choice
        answerLocked = true
        handleCheckedResult(choice == currentQuestion.answer, question: currentQuestion)
    }

    func handleCheckedResult(_ correct: Bool) {
        guard let currentQuestion else { return }
        handleCheckedResult(correct, question: currentQuestion)
    }

    func handleCheckedResult(_ correct: Bool, question: StudyQuestion) {
        guard correctAnswers < requiredCorrectAnswers else { return }

        appState.markQuestionSeen(studySetID: studySet.id, questionID: question.id)

        isCorrect = correct
        showFeedback = true

        if correct {
            let previousLevel = appState.level

            let xpEarned: Int
            switch reward {
            case 5:
                xpEarned = 10
            case 15:
                xpEarned = 20
            case 30:
                xpEarned = 40
            default:
                xpEarned = 10
            }

            withAnimation(.spring()) {
                correctAnswers += 1
                earnedMinutes += reward
            }

            appState.addTime(reward)
            appState.addXP(xpEarned)
            appState.recordCorrectAnswer(
                studySetID: studySet.id,
                questionID: question.id,
                difficulty: question.difficulty,
                xpEarned: xpEarned,
                timeEarned: reward
            )

            showTemporaryXPPopup(text: "+\(xpEarned) XP")

            if appState.level > previousLevel {
                showTemporaryLevelUpPopup()
            }
        } else {
            hadAnyWrongAnswerThisRound = true

            appState.recordIncorrectAnswer(
                studySetID: studySet.id,
                questionID: question.id,
                difficulty: question.difficulty
            )
        }

        if correctAnswers < requiredCorrectAnswers {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                showFeedback = false

                if currentQuestionIndex + 1 < questionPool.count {
                    currentQuestionIndex += 1
                } else {
                    buildQuestionPool()
                    showFeedback = false
                    selectedChoice = nil
                    answerLocked = false
                }
            }
        } else {
            showFeedback = false
        }
    }

    func choiceBackgroundColor(for choice: String, correctAnswer: String) -> Color {
        guard answerLocked, let selectedChoice else {
            return Color(.systemGray6)
        }

        if choice == correctAnswer {
            return Color.green.opacity(0.2)
        }

        if choice == selectedChoice && selectedChoice != correctAnswer {
            return Color.red.opacity(0.2)
        }

        return Color(.systemGray6)
    }

    func choiceTextColor(for choice: String, correctAnswer: String) -> Color {
        guard answerLocked, let selectedChoice else {
            return .primary
        }

        if choice == correctAnswer {
            return .green
        }

        if choice == selectedChoice && selectedChoice != correctAnswer {
            return .red
        }

        return .primary
    }

    func choiceBorderColor(for choice: String, correctAnswer: String) -> Color {
        guard answerLocked, let selectedChoice else {
            return Color.clear
        }

        if choice == correctAnswer {
            return Color.green
        }

        if choice == selectedChoice && selectedChoice != correctAnswer {
            return Color.red
        }

        return Color.clear
    }

    func showTemporaryXPPopup(text: String) {
        withAnimation(.spring()) {
            xpPopupText = text
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            withAnimation(.easeOut) {
                xpPopupText = nil
            }
        }
    }

    func showTemporaryLevelUpPopup() {
        withAnimation(.spring()) {
            showLevelUpPopup = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(.easeOut) {
                showLevelUpPopup = false
            }
        }
    }

    func showTemporaryPerfectRoundPopup() {
        withAnimation(.spring()) {
            showPerfectRoundPopup = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(.easeOut) {
                showPerfectRoundPopup = false
            }
        }
    }
}

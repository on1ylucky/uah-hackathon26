import SwiftUI

struct UnlockView: View {
    @EnvironmentObject var appState: AppState

    @State private var desiredMinutes: Double = 30
    @State private var selectedDifficulty: QuestionDifficulty = .easy
    @State private var selectedStudySetID: UUID? = nil

    let minuteOptions: [Double] = [15, 30, 45, 60]

    var selectedStudySet: StudySet? {
        guard let selectedStudySetID else { return nil }
        return appState.studySets.first(where: { $0.id == selectedStudySetID })
    }

    var desiredMinuteValue: Int {
        Int(desiredMinutes)
    }

    var availableQuestionCountForSelection: Int {
        guard let selectedStudySet else { return 0 }

        switch selectedDifficulty {
        case .easy:
            return selectedStudySet.questions.filter { $0.difficulty == .easy }.count
        case .medium:
            return selectedStudySet.questions.filter { $0.difficulty == .medium }.count
        case .hard:
            return selectedStudySet.questions.filter { $0.difficulty == .hard }.count
        case .mix:
            return selectedStudySet.questions.count
        }
    }

    var requiredCorrectAnswers: Int {
        if selectedDifficulty == .mix {
            return max(1, Int(ceil(Double(desiredMinuteValue) / 15.0)))
        } else {
            return max(1, Int(ceil(Double(desiredMinuteValue) / Double(selectedDifficulty.rewardMinutes))))
        }
    }

    var canStartQuiz: Bool {
        guard selectedStudySet != nil else { return false }
        return availableQuestionCountForSelection > 0
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                VStack(spacing: 6) {
                    Text("Unlock Time")
                        .font(.largeTitle.bold())

                    Text("Choose your time, difficulty, and study set.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Desired Minutes")
                        .font(.headline)

                    HStack(spacing: 10) {
                        ForEach(minuteOptions, id: \.self) { option in
                            Button {
                                desiredMinutes = option
                            } label: {
                                Text("\(Int(option))")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(desiredMinutes == option ? Color.green.opacity(0.2) : Color(.systemGray5))
                                    .foregroundColor(desiredMinutes == option ? .green : .primary)
                                    .cornerRadius(12)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(desiredMinuteValue) minutes")
                            .font(.subheadline.weight(.semibold))

                        Slider(value: $desiredMinutes, in: 5...120, step: 5)
                            .tint(.green)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(18)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Difficulty")
                        .font(.headline)

                    ForEach(QuestionDifficulty.allCases) { difficulty in
                        Button {
                            selectedDifficulty = difficulty
                        } label: {
                            HStack {
                                Text(difficulty.displayName)
                                    .fontWeight(.semibold)

                                Spacer()

                                if difficulty == .mix {
                                    Text("Estimated: \(max(1, Int(ceil(Double(desiredMinuteValue) / 15.0)))) correct")
                                        .font(.caption)
                                } else {
                                    Text("\(max(1, Int(ceil(Double(desiredMinuteValue) / Double(difficulty.rewardMinutes))))) correct")
                                        .font(.caption)
                                }

                                if selectedDifficulty == difficulty {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                            .background(
                                selectedDifficulty == difficulty
                                ? difficulty.color.opacity(0.2)
                                : Color(.systemGray6)
                            )
                            .cornerRadius(16)
                            .scaleEffect(selectedDifficulty == difficulty ? 1.02 : 1.0)
                            .animation(.spring(), value: selectedDifficulty)
                        }
                        .buttonStyle(.plain)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Study Set")
                        .font(.headline)

                    Picker("Select Study Set", selection: $selectedStudySetID) {
                        Text("Choose a study set").tag(Optional<UUID>.none)

                        ForEach(appState.studySets) { set in
                            Text(set.title).tag(Optional(set.id))
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    if let selectedStudySet {
                        Text("\(availableQuestionCountForSelection) questions available in \(selectedDifficulty.displayName.lowercased()) mode")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        if availableQuestionCountForSelection == 0 {
                            Text("No questions available for this difficulty.")
                                .font(.caption)
                                .foregroundColor(.red)
                        }

                        Text("To earn \(desiredMinuteValue) minutes, you need \(requiredCorrectAnswers) correct answers.")
                            .font(.subheadline.weight(.semibold))
                            .padding(.top, 4)
                    }
                }

                if let selectedStudySet {
                    NavigationLink {
                        QuizView(
                            desiredMinutes: desiredMinuteValue,
                            selectedDifficulty: selectedDifficulty,
                            requiredCorrectAnswers: requiredCorrectAnswers,
                            studySet: selectedStudySet
                        )
                    } label: {
                        Text("Start")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canStartQuiz ? Color.green : Color.gray.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(18)
                    }
                    .disabled(!canStartQuiz)
                } else {
                    Text("Choose a study set to continue.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .padding(.bottom, 24)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

import SwiftUI

struct StudySetDetailView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    let studySetID: UUID

    @State private var editingSetTitle: String = ""
    @State private var editingSetSubject: String = ""

    @State private var editingQuestionID: UUID? = nil
    @State private var questionPrompt: String = ""
    @State private var questionAnswer: String = ""
    @State private var wrongChoice1: String = ""
    @State private var wrongChoice2: String = ""
    @State private var wrongChoice3: String = ""
    @State private var questionExplanation: String = ""
    @State private var selectedDifficulty: QuestionDifficulty = .easy

    @State private var showResetProgressAlert = false
    @State private var showDeleteSetAlert = false
    @State private var questionToDelete: StudyQuestion? = nil

    var studySet: StudySet? {
        appState.studySets.first(where: { $0.id == studySetID })
    }

    var easyQuestions: [StudyQuestion] {
        guard let studySet else { return [] }
        return studySet.questions.filter { $0.difficulty == .easy }
    }

    var mediumQuestions: [StudyQuestion] {
        guard let studySet else { return [] }
        return studySet.questions.filter { $0.difficulty == .medium }
    }

    var hardQuestions: [StudyQuestion] {
        guard let studySet else { return [] }
        return studySet.questions.filter { $0.difficulty == .hard }
    }

    var body: some View {
        ScrollView {
            if let studySet {
                VStack(spacing: 20) {
                    editStudySetSection(studySet)
                    questionEditorSection(studySet)
                    questionListSection(studySet)
                }
                .padding()
                .padding(.bottom, 24)
                .onAppear {
                    editingSetTitle = studySet.title
                    editingSetSubject = studySet.subject
                }
            } else {
                missingSetSection
            }
        }
        .navigationTitle(studySet?.title ?? "Study Set")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Reset progress for this study set?", isPresented: $showResetProgressAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                appState.resetStudySetProgress(studySetID: studySetID)
            }
        } message: {
            Text("This will clear completion, accuracy, streaks, and other progress for this set, but keep the questions.")
        }
        .alert("Delete this study set?", isPresented: $showDeleteSetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                appState.deleteStudySet(studySetID: studySetID)
                dismiss()
            }
        } message: {
            Text("This will permanently remove the study set and all of its questions.")
        }
        .alert(
            "Delete this question?",
            isPresented: Binding(
                get: { questionToDelete != nil },
                set: { if !$0 { questionToDelete = nil } }
            )
        ) {
            Button("Cancel", role: .cancel) {
                questionToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let question = questionToDelete {
                    appState.deleteQuestion(from: studySetID, questionID: question.id)

                    if editingQuestionID == question.id {
                        clearQuestionForm()
                    }
                }
                questionToDelete = nil
            }
        } message: {
            Text("This question will be permanently removed from the study set.")
        }
    }

    @ViewBuilder
    func editStudySetSection(_ studySet: StudySet) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Edit Study Set")
                .font(.title2.bold())

            TextField("Set Title", text: $editingSetTitle)
                .textFieldStyle(.roundedBorder)

            TextField("Subject / Class", text: $editingSetSubject)
                .textFieldStyle(.roundedBorder)

            Button("Save Set Changes") {
                appState.updateStudySet(
                    studySetID: studySet.id,
                    title: editingSetTitle,
                    subject: editingSetSubject
                )
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(canSaveStudySet ? Color.blue : Color.gray.opacity(0.4))
            .foregroundColor(.white)
            .cornerRadius(14)
            .disabled(!canSaveStudySet)

            HStack(spacing: 10) {
                Button("Reset Progress") {
                    showResetProgressAlert = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange.opacity(0.15))
                .foregroundColor(.orange)
                .cornerRadius(14)

                Button("Delete Set") {
                    showDeleteSetAlert = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.15))
                .foregroundColor(.red)
                .cornerRadius(14)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(18)
    }

    @ViewBuilder
    func questionEditorSection(_ studySet: StudySet) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(editingQuestionID == nil ? "Add Question" : "Edit Question")
                .font(.title2.bold())

            TextField("Question Prompt", text: $questionPrompt, axis: .vertical)
                .textFieldStyle(.roundedBorder)

            TextField("Correct Answer", text: $questionAnswer)
                .textFieldStyle(.roundedBorder)

            TextField("Wrong Choice 1", text: $wrongChoice1)
                .textFieldStyle(.roundedBorder)

            TextField("Wrong Choice 2", text: $wrongChoice2)
                .textFieldStyle(.roundedBorder)

            TextField("Wrong Choice 3", text: $wrongChoice3)
                .textFieldStyle(.roundedBorder)

            TextField("Explanation (optional)", text: $questionExplanation, axis: .vertical)
                .textFieldStyle(.roundedBorder)

            Picker("Difficulty", selection: $selectedDifficulty) {
                Text("Easy").tag(QuestionDifficulty.easy)
                Text("Medium").tag(QuestionDifficulty.medium)
                Text("Hard").tag(QuestionDifficulty.hard)
            }
            .pickerStyle(.segmented)

            if editingQuestionID == nil {
                Button("Add Question") {
                    let allChoices = [
                        questionAnswer.trimmingCharacters(in: .whitespacesAndNewlines),
                        wrongChoice1.trimmingCharacters(in: .whitespacesAndNewlines),
                        wrongChoice2.trimmingCharacters(in: .whitespacesAndNewlines),
                        wrongChoice3.trimmingCharacters(in: .whitespacesAndNewlines)
                    ]

                    appState.addQuestion(
                        to: studySet.id,
                        prompt: questionPrompt,
                        answer: questionAnswer,
                        choices: allChoices,
                        difficulty: selectedDifficulty,
                        explanation: questionExplanation
                    )

                    clearQuestionForm()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(canSaveQuestion ? Color.green : Color.gray.opacity(0.4))
                .foregroundColor(.white)
                .cornerRadius(14)
                .disabled(!canSaveQuestion)
            } else {
                VStack(spacing: 10) {
                    Button("Save Changes") {
                        guard let editingQuestionID else { return }

                        let allChoices = [
                            questionAnswer.trimmingCharacters(in: .whitespacesAndNewlines),
                            wrongChoice1.trimmingCharacters(in: .whitespacesAndNewlines),
                            wrongChoice2.trimmingCharacters(in: .whitespacesAndNewlines),
                            wrongChoice3.trimmingCharacters(in: .whitespacesAndNewlines)
                        ]

                        appState.updateQuestion(
                            in: studySet.id,
                            questionID: editingQuestionID,
                            prompt: questionPrompt,
                            answer: questionAnswer,
                            choices: allChoices,
                            difficulty: selectedDifficulty,
                            explanation: questionExplanation
                        )

                        clearQuestionForm()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canSaveQuestion ? Color.blue : Color.gray.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .disabled(!canSaveQuestion)

                    Button("Cancel Editing") {
                        clearQuestionForm()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .cornerRadius(14)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(18)
    }

    @ViewBuilder
    func questionListSection(_ studySet: StudySet) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Questions in \(studySet.title)")
                .font(.title3.bold())

            if studySet.questions.isEmpty {
                VStack(spacing: 10) {
                    Text("No questions yet 👀")
                        .font(.headline)

                    Text("Start by adding your first flashcard above.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(Color(.systemGray6))
                .cornerRadius(16)
            } else {
                questionSection(title: "Easy", color: .green, questions: easyQuestions)
                questionSection(title: "Medium", color: .orange, questions: mediumQuestions)
                questionSection(title: "Hard", color: .red, questions: hardQuestions)
            }
        }
    }

    @ViewBuilder
    func questionSection(title: String, color: Color, questions: [StudyQuestion]) -> some View {
        if !questions.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(title)
                        .font(.headline)

                    Spacer()

                    Text("\(questions.count)")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(color.opacity(0.15))
                        .foregroundColor(color)
                        .cornerRadius(10)
                }

                ForEach(questions) { question in
                    questionCard(question)
                }
            }
        }
    }

    @ViewBuilder
    func questionCard(_ question: StudyQuestion) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 6) {
                Text(question.prompt)
                    .font(.headline)

                Text("Answer: \(question.answer)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("Difficulty: \(question.difficulty.displayName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 10) {
                Button("Edit") {
                    loadQuestionIntoForm(question)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.15))
                .foregroundColor(.blue)
                .cornerRadius(10)

                Button("Delete") {
                    questionToDelete = question
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.red.opacity(0.15))
                .foregroundColor(.red)
                .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }

    var missingSetSection: some View {
        VStack(spacing: 12) {
            Text("Study Set Not Found")
                .font(.title2.bold())

            Text("This study set may have been deleted.")
                .foregroundColor(.secondary)
        }
        .padding()
    }

    var canSaveStudySet: Bool {
        !editingSetTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !editingSetSubject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var canSaveQuestion: Bool {
        !questionPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !questionAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !wrongChoice1.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !wrongChoice2.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !wrongChoice3.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func loadQuestionIntoForm(_ question: StudyQuestion) {
        editingQuestionID = question.id
        questionPrompt = question.prompt
        questionAnswer = question.answer
        selectedDifficulty = question.difficulty
        questionExplanation = question.explanation ?? ""

        let wrongChoices = question.choices.filter { $0 != question.answer }
        wrongChoice1 = wrongChoices.indices.contains(0) ? wrongChoices[0] : ""
        wrongChoice2 = wrongChoices.indices.contains(1) ? wrongChoices[1] : ""
        wrongChoice3 = wrongChoices.indices.contains(2) ? wrongChoices[2] : ""
    }

    func clearQuestionForm() {
        editingQuestionID = nil
        questionPrompt = ""
        questionAnswer = ""
        wrongChoice1 = ""
        wrongChoice2 = ""
        wrongChoice3 = ""
        questionExplanation = ""
    }
}

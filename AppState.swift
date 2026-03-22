import SwiftUI
import Combine

final class AppState: ObservableObject {
    @Published var timeBank: Int { didSet { saveAll() } }
    @Published var xp: Int { didSet { saveAll() } }
    @Published var level: Int { didSet { saveAll() } }
    @Published var streak: Int { didSet { saveAll() } }

    @Published var questionMode: QuestionMode { didSet { saveAll() } }
    @Published var shuffleQuestions: Bool { didSet { saveAll() } }
    @Published var caseSensitiveAnswers: Bool { didSet { saveAll() } }

    @Published var studySets: [StudySet] { didSet { saveAll() } }
    @Published var studySetProgress: [UUID: StudySetProgress] { didSet { saveAll() } }
    @Published var lockedApps: [LockedApp] { didSet { saveAll() } }

    private enum StorageKeys {
        static let timeBank = "studylock.timeBank"
        static let xp = "studylock.xp"
        static let level = "studylock.level"
        static let streak = "studylock.streak"
        static let questionMode = "studylock.questionMode"
        static let shuffleQuestions = "studylock.shuffleQuestions"
        static let caseSensitiveAnswers = "studylock.caseSensitiveAnswers"
        static let studySets = "studylock.studySets"
        static let studySetProgress = "studylock.studySetProgress"
        static let lockedApps = "studylock.lockedApps"
    }

    init() {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()

        timeBank = defaults.object(forKey: StorageKeys.timeBank) as? Int ?? 25
        xp = defaults.object(forKey: StorageKeys.xp) as? Int ?? 0
        level = defaults.object(forKey: StorageKeys.level) as? Int ?? 1
        streak = defaults.object(forKey: StorageKeys.streak) as? Int ?? 0

        if let raw = defaults.string(forKey: StorageKeys.questionMode),
           let mode = QuestionMode(rawValue: raw) {
            questionMode = mode
        } else {
            questionMode = .multipleChoice
        }

        if defaults.object(forKey: StorageKeys.shuffleQuestions) == nil {
            shuffleQuestions = true
        } else {
            shuffleQuestions = defaults.bool(forKey: StorageKeys.shuffleQuestions)
        }

        if defaults.object(forKey: StorageKeys.caseSensitiveAnswers) == nil {
            caseSensitiveAnswers = false
        } else {
            caseSensitiveAnswers = defaults.bool(forKey: StorageKeys.caseSensitiveAnswers)
        }

        if let data = defaults.data(forKey: StorageKeys.studySets),
           let decoded = try? decoder.decode([StudySet].self, from: data) {
            studySets = decoded
        } else {
            studySets = MockData.allStudySets
        }

        if let data = defaults.data(forKey: StorageKeys.studySetProgress),
           let decoded = try? decoder.decode([UUID: StudySetProgress].self, from: data) {
            studySetProgress = decoded
        } else {
            studySetProgress = [:]
        }

        if let data = defaults.data(forKey: StorageKeys.lockedApps),
           let decoded = try? decoder.decode([LockedApp].self, from: data) {
            lockedApps = decoded
        } else {
            lockedApps = MockData.lockedApps
        }

        for set in studySets where studySetProgress[set.id] == nil {
            studySetProgress[set.id] = StudySetProgress()
        }
    }

    private func saveAll() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()

        defaults.set(timeBank, forKey: StorageKeys.timeBank)
        defaults.set(xp, forKey: StorageKeys.xp)
        defaults.set(level, forKey: StorageKeys.level)
        defaults.set(streak, forKey: StorageKeys.streak)
        defaults.set(questionMode.rawValue, forKey: StorageKeys.questionMode)
        defaults.set(shuffleQuestions, forKey: StorageKeys.shuffleQuestions)
        defaults.set(caseSensitiveAnswers, forKey: StorageKeys.caseSensitiveAnswers)

        if let data = try? encoder.encode(studySets) {
            defaults.set(data, forKey: StorageKeys.studySets)
        }

        if let data = try? encoder.encode(studySetProgress) {
            defaults.set(data, forKey: StorageKeys.studySetProgress)
        }

        if let data = try? encoder.encode(lockedApps) {
            defaults.set(data, forKey: StorageKeys.lockedApps)
        }
    }

    var xpNeededForNextLevel: Int {
        level * 100
    }

    var levelProgress: Double {
        guard xpNeededForNextLevel > 0 else { return 0 }
        return Double(xp) / Double(xpNeededForNextLevel)
    }

    func addTime(_ minutes: Int) {
        timeBank += minutes
    }

    func spendTime(_ minutes: Int) {
        timeBank = max(0, timeBank - minutes)
    }

    func addXP(_ amount: Int) {
        xp += amount

        while xp >= xpNeededForNextLevel {
            xp -= xpNeededForNextLevel
            level += 1
        }
    }

    func incrementStreak() {
        streak += 1
    }

    func breakStreak() {
        streak = 0
    }

    func addStudySet(title: String, subject: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedSubject = subject.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty, !trimmedSubject.isEmpty else { return }

        let newSet = StudySet(title: trimmedTitle, subject: trimmedSubject, questions: [])
        studySets.append(newSet)
        studySetProgress[newSet.id] = StudySetProgress()
    }

    func updateStudySet(studySetID: UUID, title: String, subject: String) {
        guard let index = studySets.firstIndex(where: { $0.id == studySetID }) else { return }

        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedSubject = subject.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty, !trimmedSubject.isEmpty else { return }

        studySets[index].title = trimmedTitle
        studySets[index].subject = trimmedSubject
    }

    func deleteStudySet(studySetID: UUID) {
        studySets.removeAll { $0.id == studySetID }
        studySetProgress.removeValue(forKey: studySetID)

        for index in lockedApps.indices where lockedApps[index].studySetID == studySetID {
            lockedApps[index].studySetID = nil
        }

        if studySets.isEmpty {
            studySets = MockData.allStudySets
            for set in studySets where studySetProgress[set.id] == nil {
                studySetProgress[set.id] = StudySetProgress()
            }
        }
    }

    func resetStudySetProgress(studySetID: UUID) {
        studySetProgress[studySetID] = StudySetProgress()
    }

    func addQuestion(
        to studySetID: UUID,
        prompt: String,
        answer: String,
        choices: [String],
        difficulty: QuestionDifficulty,
        explanation: String?
    ) {
        guard let index = studySets.firstIndex(where: { $0.id == studySetID }) else { return }

        let trimmedPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAnswer = answer.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedChoices = choices.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let trimmedExplanation = explanation?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedPrompt.isEmpty, !trimmedAnswer.isEmpty else { return }
        guard trimmedChoices.allSatisfy({ !$0.isEmpty }) else { return }

        let newQuestion = StudyQuestion(
            prompt: trimmedPrompt,
            answer: trimmedAnswer,
            choices: trimmedChoices,
            difficulty: difficulty,
            explanation: trimmedExplanation?.isEmpty == true ? nil : trimmedExplanation
        )

        studySets[index].questions.append(newQuestion)
    }

    func updateQuestion(
        in studySetID: UUID,
        questionID: UUID,
        prompt: String,
        answer: String,
        choices: [String],
        difficulty: QuestionDifficulty,
        explanation: String?
    ) {
        guard let setIndex = studySets.firstIndex(where: { $0.id == studySetID }) else { return }
        guard let questionIndex = studySets[setIndex].questions.firstIndex(where: { $0.id == questionID }) else { return }

        let trimmedPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAnswer = answer.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedChoices = choices.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let trimmedExplanation = explanation?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedPrompt.isEmpty, !trimmedAnswer.isEmpty else { return }
        guard trimmedChoices.allSatisfy({ !$0.isEmpty }) else { return }

        studySets[setIndex].questions[questionIndex].prompt = trimmedPrompt
        studySets[setIndex].questions[questionIndex].answer = trimmedAnswer
        studySets[setIndex].questions[questionIndex].choices = trimmedChoices
        studySets[setIndex].questions[questionIndex].difficulty = difficulty
        studySets[setIndex].questions[questionIndex].explanation = trimmedExplanation?.isEmpty == true ? nil : trimmedExplanation
    }

    func deleteQuestion(from studySetID: UUID, questionID: UUID) {
        guard let setIndex = studySets.firstIndex(where: { $0.id == studySetID }) else { return }
        studySets[setIndex].questions.removeAll { $0.id == questionID }

        studySetProgress[studySetID]?.completedQuestionIDs.remove(questionID)
        studySetProgress[studySetID]?.seenQuestionIDs.remove(questionID)
    }

    func addLockedApp(
        name: String,
        icon: String,
        requiredCorrect: Int,
        requiredDifficulty: QuestionDifficulty,
        studySetID: UUID?
    ) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedIcon = icon.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty, !trimmedIcon.isEmpty else { return }

        let newApp = LockedApp(
            name: trimmedName,
            icon: trimmedIcon,
            requiredCorrect: max(5, requiredCorrect),
            requiredDifficulty: requiredDifficulty,
            studySetID: studySetID
        )

        lockedApps.append(newApp)
    }

    func deleteLockedApp(appID: UUID) {
        lockedApps.removeAll { $0.id == appID }
    }

    func updateLockedAppRequirement(appID: UUID, requiredCorrect: Int) {
        guard let index = lockedApps.firstIndex(where: { $0.id == appID }) else { return }
        lockedApps[index].requiredCorrect = max(5, requiredCorrect)
    }

    func updateLockedAppDifficulty(appID: UUID, difficulty: QuestionDifficulty) {
        guard let index = lockedApps.firstIndex(where: { $0.id == appID }) else { return }
        lockedApps[index].requiredDifficulty = difficulty
    }

    func updateLockedAppStudySet(appID: UUID, studySetID: UUID?) {
        guard let index = lockedApps.firstIndex(where: { $0.id == appID }) else { return }
        lockedApps[index].studySetID = studySetID
    }

    func progress(for studySetID: UUID) -> StudySetProgress {
        if let existing = studySetProgress[studySetID] {
            return existing
        }
        let newProgress = StudySetProgress()
        studySetProgress[studySetID] = newProgress
        return newProgress
    }

    func resetRound(for studySetID: UUID) {
        studySetProgress[studySetID]?.completedQuestionIDs = []
        studySetProgress[studySetID]?.seenQuestionIDs = []
        studySetProgress[studySetID]?.correctAnswers = 0
        studySetProgress[studySetID]?.incorrectAnswers = 0
        studySetProgress[studySetID]?.currentCorrectStreak = 0
    }

    func markQuestionSeen(studySetID: UUID, questionID: UUID) {
        if studySetProgress[studySetID] == nil {
            studySetProgress[studySetID] = StudySetProgress()
        }
        studySetProgress[studySetID]?.seenQuestionIDs.insert(questionID)
        studySetProgress[studySetID]?.lastPracticedDate = Date()
    }

    func recordCorrectAnswer(
        studySetID: UUID,
        questionID: UUID,
        difficulty: QuestionDifficulty,
        xpEarned: Int,
        timeEarned: Int
    ) {
        if studySetProgress[studySetID] == nil {
            studySetProgress[studySetID] = StudySetProgress()
        }

        studySetProgress[studySetID]?.completedQuestionIDs.insert(questionID)
        studySetProgress[studySetID]?.seenQuestionIDs.insert(questionID)
        studySetProgress[studySetID]?.correctAnswers += 1
        studySetProgress[studySetID]?.currentCorrectStreak += 1
        studySetProgress[studySetID]?.bestCorrectStreak = max(
            studySetProgress[studySetID]?.bestCorrectStreak ?? 0,
            studySetProgress[studySetID]?.currentCorrectStreak ?? 0
        )
        studySetProgress[studySetID]?.xpEarned += xpEarned
        studySetProgress[studySetID]?.timeEarnedMinutes += timeEarned
        studySetProgress[studySetID]?.lastPracticedDate = Date()
    }

    func recordIncorrectAnswer(
        studySetID: UUID,
        questionID: UUID,
        difficulty: QuestionDifficulty
    ) {
        if studySetProgress[studySetID] == nil {
            studySetProgress[studySetID] = StudySetProgress()
        }

        studySetProgress[studySetID]?.seenQuestionIDs.insert(questionID)
        studySetProgress[studySetID]?.incorrectAnswers += 1
        studySetProgress[studySetID]?.currentCorrectStreak = 0
        studySetProgress[studySetID]?.lastPracticedDate = Date()

        switch difficulty {
        case .easy:
            studySetProgress[studySetID]?.easyMisses += 1
        case .medium:
            studySetProgress[studySetID]?.mediumMisses += 1
        case .hard:
            studySetProgress[studySetID]?.hardMisses += 1
        case .mix:
            break
        }
    }

    func markRoundCompleted(for studySetID: UUID) {
        if studySetProgress[studySetID] == nil {
            studySetProgress[studySetID] = StudySetProgress()
        }

        studySetProgress[studySetID]?.roundsCompleted += 1
        studySetProgress[studySetID]?.lastCompletedDate = Date()
    }

    func mostMissedDifficulty(for studySetID: UUID) -> String {
        let progress = progress(for: studySetID)
        let pairs = [
            ("Easy", progress.easyMisses),
            ("Medium", progress.mediumMisses),
            ("Hard", progress.hardMisses)
        ]

        guard let top = pairs.max(by: { $0.1 < $1.1 }), top.1 > 0 else {
            return "None yet"
        }

        return top.0
    }

    func completionRate(for studySet: StudySet) -> Double {
        guard !studySet.questions.isEmpty else { return 0 }
        let progress = progress(for: studySet.id)
        return Double(progress.completedQuestionIDs.count) / Double(studySet.questions.count)
    }

    func completionText(for studySet: StudySet) -> String {
        let progress = progress(for: studySet.id)
        return "\(progress.completedQuestionIDs.count) / \(studySet.questions.count)"
    }
}

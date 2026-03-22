import SwiftUI

enum QuestionDifficulty: String, CaseIterable, Identifiable, Codable {
    case easy
    case medium
    case hard
    case mix

    var id: String { rawValue }

    var rewardMinutes: Int {
        switch self {
        case .easy: return 5
        case .medium: return 15
        case .hard: return 30
        case .mix: return 0
        }
    }

    var displayName: String {
        rawValue.capitalized
    }

    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        case .mix: return .blue
        }
    }
}

enum QuestionMode: String, CaseIterable, Identifiable, Codable {
    case multipleChoice = "Multiple Choice"
    case typedAnswer = "Typed Answer"

    var id: String { rawValue }
}

struct StudyQuestion: Identifiable, Codable {
    let id: UUID
    var prompt: String
    var answer: String
    var choices: [String]
    var difficulty: QuestionDifficulty
    var explanation: String?

    init(
        id: UUID = UUID(),
        prompt: String,
        answer: String,
        choices: [String],
        difficulty: QuestionDifficulty,
        explanation: String?
    ) {
        self.id = id
        self.prompt = prompt
        self.answer = answer
        self.choices = choices
        self.difficulty = difficulty
        self.explanation = explanation
    }
}

struct StudySet: Identifiable, Codable {
    let id: UUID
    var title: String
    var subject: String
    var questions: [StudyQuestion]

    init(
        id: UUID = UUID(),
        title: String,
        subject: String,
        questions: [StudyQuestion]
    ) {
        self.id = id
        self.title = title
        self.subject = subject
        self.questions = questions
    }
}

struct LockedApp: Identifiable, Codable {
    let id: UUID
    var name: String
    var icon: String
    var requiredCorrect: Int
    var requiredDifficulty: QuestionDifficulty
    var studySetID: UUID?
    var isDemoLinked: Bool

    init(
        id: UUID = UUID(),
        name: String,
        icon: String,
        requiredCorrect: Int,
        requiredDifficulty: QuestionDifficulty = .easy,
        studySetID: UUID? = nil,
        isDemoLinked: Bool = false
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.requiredCorrect = max(5, requiredCorrect)
        self.requiredDifficulty = requiredDifficulty
        self.studySetID = studySetID
        self.isDemoLinked = isDemoLinked
    }
}

struct StudySetProgress: Codable {
    var completedQuestionIDs: Set<UUID> = []
    var seenQuestionIDs: Set<UUID> = []
    var correctAnswers: Int = 0
    var incorrectAnswers: Int = 0
    var roundsCompleted: Int = 0
    var currentCorrectStreak: Int = 0
    var bestCorrectStreak: Int = 0
    var xpEarned: Int = 0
    var timeEarnedMinutes: Int = 0
    var lastPracticedDate: Date? = nil
    var lastCompletedDate: Date? = nil
    var easyMisses: Int = 0
    var mediumMisses: Int = 0
    var hardMisses: Int = 0

    var totalAttempts: Int {
        correctAnswers + incorrectAnswers
    }

    var accuracyRate: Double {
        guard totalAttempts > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalAttempts)
    }
}

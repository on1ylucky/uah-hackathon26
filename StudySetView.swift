import SwiftUI

struct StudySetsView: View {
    @EnvironmentObject var appState: AppState

    @State private var newSetTitle: String = ""
    @State private var newSetSubject: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Create Study Set")
                        .font(.title2.bold())

                    TextField("Set Title", text: $newSetTitle)
                        .textFieldStyle(.roundedBorder)

                    TextField("Subject / Class", text: $newSetSubject)
                        .textFieldStyle(.roundedBorder)

                    Button("Add Study Set") {
                        appState.addStudySet(title: newSetTitle, subject: newSetSubject)
                        newSetTitle = ""
                        newSetSubject = ""
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canAddStudySet ? Color.green : Color.gray.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .disabled(!canAddStudySet)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(18)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Study Sets")
                        .font(.title2.bold())

                    if appState.studySets.isEmpty {
                        VStack(spacing: 10) {
                            Text("No study sets yet 👀")
                                .font(.headline)

                            Text("Create your first study set above to start building flashcards.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(24)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    } else {
                        ForEach(appState.studySets) { set in
                            NavigationLink {
                                StudySetDetailView(studySetID: set.id)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(set.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)

                                        Text(set.subject)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)

                                        Text("\(set.questions.count) questions")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
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
        .navigationTitle("Study Sets")
    }

    var canAddStudySet: Bool {
        !newSetTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !newSetSubject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

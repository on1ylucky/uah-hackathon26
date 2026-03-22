import SwiftUI

struct MoreView: View {
    @EnvironmentObject var appState: AppState

    @State private var reminderEnabled = false
    @State private var reminderStatusText = "No reminder scheduled."

    @State private var newLockedAppName = ""
    @State private var newLockedAppIcon = "app.fill"

    @State private var showLinkInfoAlert = false
    @State private var linkInfoAppName = ""

    let iconOptions = [
        "app.fill",
        "camera.fill",
        "message.fill",
        "music.note",
        "play.rectangle.fill",
        "gamecontroller.fill",
        "globe",
        "photo.fill",
        "bubble.left.and.bubble.right.fill",
        "tv.fill"
    ]

    var body: some View {
        List {
            Section("Question Mode") {
                Picker(selection: $appState.questionMode) {
                    ForEach(QuestionMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                } label: {
                    EmptyView()
                }
                .labelsHidden()
                .pickerStyle(.inline)

                Text("Current mode: \(appState.questionMode.rawValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Section("Quiz Options") {
                VStack(alignment: .leading, spacing: 6) {
                    Toggle("Shuffle Questions", isOn: $appState.shuffleQuestions)

                    Text("Shuffle changes the order questions appear in each round.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)

                VStack(alignment: .leading, spacing: 6) {
                    Toggle("Case Sensitive Answers", isOn: $appState.caseSensitiveAnswers)

                    Text("Case sensitive answers only affect typed answer mode.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section("Add Locked App") {
                TextField("App Name", text: $newLockedAppName)

                Picker("Icon", selection: $newLockedAppIcon) {
                    ForEach(iconOptions, id: \.self) { icon in
                        Label(icon, systemImage: icon).tag(icon)
                    }
                }

                Button("Add App to Lock") {
                    appState.addLockedApp(
                        name: newLockedAppName,
                        icon: newLockedAppIcon,
                        requiredCorrect: 5,
                        requiredDifficulty: .easy,
                        studySetID: nil
                    )

                    newLockedAppName = ""
                    newLockedAppIcon = "app.fill"
                }
                .disabled(newLockedAppName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            Section("Locked App Rules") {
                if appState.lockedApps.isEmpty {
                    Text("No locked apps yet.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach($appState.lockedApps) { $app in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: app.icon)
                                    .frame(width: 24)

                                Text(app.name)
                                    .font(.headline)

                                Spacer()

                                Button("Delete") {
                                    appState.deleteLockedApp(appID: app.id)
                                }
                                .foregroundColor(.red)
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Real App Link")
                                    .font(.subheadline.weight(.semibold))

                                HStack {
                                    Text(app.isDemoLinked ? "Demo Linked" : "Not Linked")
                                        .font(.caption.weight(.semibold))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(
                                            app.isDemoLinked
                                            ? Color.green.opacity(0.15)
                                            : Color.gray.opacity(0.15)
                                        )
                                        .foregroundColor(app.isDemoLinked ? .green : .secondary)
                                        .cornerRadius(10)

                                    Spacer()

                                    Button(app.isDemoLinked ? "Unlink" : "Link Real App") {
                                        app.isDemoLinked.toggle()
                                        linkInfoAppName = app.name
                                        showLinkInfoAlert = true
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Questions Required: \(app.requiredCorrect)")
                                    .font(.subheadline.weight(.semibold))

                                Stepper(
                                    "Adjust question count",
                                    value: $app.requiredCorrect,
                                    in: 5...25,
                                    step: 1
                                )
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Required Difficulty")
                                    .font(.subheadline.weight(.semibold))

                                Picker("Required Difficulty", selection: $app.requiredDifficulty) {
                                    Text("Easy").tag(QuestionDifficulty.easy)
                                    Text("Medium").tag(QuestionDifficulty.medium)
                                    Text("Hard").tag(QuestionDifficulty.hard)
                                    Text("Mix").tag(QuestionDifficulty.mix)
                                }
                                .pickerStyle(.segmented)
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Study Set")
                                    .font(.subheadline.weight(.semibold))

                                Picker("Study Set", selection: $app.studySetID) {
                                    Text("Choose a study set").tag(Optional<UUID>.none)
                                    ForEach(appState.studySets) { set in
                                        Text(set.title).tag(Optional(set.id))
                                    }
                                }
                            }

                            Text(summaryText(for: app))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }

            Section("Reminders") {
                VStack(alignment: .leading, spacing: 6) {
                    Toggle("Daily Study Reminder", isOn: $reminderEnabled)
                        .onChange(of: reminderEnabled) { _, newValue in
                            Task {
                                if newValue {
                                    let granted = await NotificationManager.shared.requestPermission()
                                    if granted {
                                        await NotificationManager.shared.scheduleDailyReminder()
                                        reminderStatusText = "Daily reminder set for 6:00 PM."
                                    } else {
                                        reminderEnabled = false
                                        reminderStatusText = "Notifications not allowed."
                                    }
                                } else {
                                    NotificationManager.shared.clearDailyReminder()
                                    reminderStatusText = "No reminder scheduled."
                                }
                            }
                        }

                    Text(reminderStatusText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section("Simulation") {
                NavigationLink("Simulation Demo") {
                    SimulationDemoView()
                }
            }

            Section("Emergency") {
                VStack(alignment: .leading, spacing: 6) {
                    Button("Emergency Unlock") {
                        appState.breakStreak()
                        appState.xp = max(0, appState.xp - 50)
                    }
                    .foregroundColor(.red)

                    Text("Emergency unlock breaks your streak and removes 50 XP.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section("Settings") {
                Text("Your study sets, progress, locked apps, and options are saved locally on this device.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("More")
        .alert(linkAlertTitle, isPresented: $showLinkInfoAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(linkAlertMessage)
        }
    }

    var linkAlertTitle: String {
        "Demo App Linking"
    }

    var linkAlertMessage: String {
        "For the demo, \(linkInfoAppName) is now marked as linked. In the full version, this would connect through Apple’s supported app selection and Screen Time flow."
    }

    func summaryText(for app: LockedApp) -> String {
        let setName = appState.studySets.first(where: { $0.id == app.studySetID })?.title ?? "No study set selected"
        let linkStatus = app.isDemoLinked ? "Demo linked" : "Not linked"
        return "\(linkStatus) • Requires at least \(app.requiredCorrect) \(app.requiredDifficulty.displayName.lowercased()) question(s) from \(setName)."
    }
}

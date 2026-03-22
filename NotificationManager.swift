import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private init() { }

    func requestPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    func scheduleDailyReminder(hour: Int = 18, minute: Int = 0) async {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["studylock.daily.reminder"])

        let content = UNMutableNotificationContent()
        content.title = "Keep your streak alive"
        content.body = "Study a little and earn more screen time today."
        content.sound = .default

        var date = DateComponents()
        date.hour = hour
        date.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(
            identifier: "studylock.daily.reminder",
            content: content,
            trigger: trigger
        )

        do {
            try await center.add(request)
        } catch {
            // no-op for now
        }
    }

    func clearDailyReminder() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["studylock.daily.reminder"])
    }
}

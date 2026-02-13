import Foundation
import UserNotifications

protocol NotificationServicing {
    func requestAuthorization() async -> Bool
    func currentAuthorizationStatus() async -> UNAuthorizationStatus
    func scheduleTimerFinishedNotification(at endDate: Date) async
    func cancelTimerNotification() async
}

final class NotificationService: NotificationServicing {
    private let center = UNUserNotificationCenter.current()
    private let timerNotificationId = "com.tylian.timerfuturiste.timer.finished"

    func requestAuthorization() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    func currentAuthorizationStatus() async -> UNAuthorizationStatus {
        await withCheckedContinuation { continuation in
            center.getNotificationSettings { settings in
                continuation.resume(returning: settings.authorizationStatus)
            }
        }
    }

    func scheduleTimerFinishedNotification(at endDate: Date) async {
        let content = UNMutableNotificationContent()
        content.title = "Minuteur terminé"
        content.body = "Le compte à rebours est arrivé à zéro."
        content.sound = .default

        let delay = max(1, Int(endDate.timeIntervalSinceNow.rounded()))
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delay), repeats: false)
        let request = UNNotificationRequest(
            identifier: timerNotificationId,
            content: content,
            trigger: trigger
        )
        try? await center.add(request)
    }

    func cancelTimerNotification() async {
        center.removePendingNotificationRequests(withIdentifiers: [timerNotificationId])
    }
}


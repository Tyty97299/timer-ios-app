import Foundation
import UserNotifications

@MainActor
final class TimerViewModel: ObservableObject {
    @Published private(set) var snapshot: TimerSnapshot = .empty
    @Published var customMinutes: String = ""
    @Published var showNotificationBanner = false
    @Published var notificationStatusText = ""

    let presets: [TimeInterval] = [60, 5 * 60, 10 * 60, 25 * 60]

    private let engine: TimerControlling
    private let notificationService: NotificationServicing
    private let liveActivityService: LiveActivityControlling
    private let hapticsAudioService: HapticsAudioServicing
    private let persistenceService: PersistenceServicing
    private var lastLiveActivitySecond = -1

    init(
        engine: TimerControlling,
        notificationService: NotificationServicing,
        liveActivityService: LiveActivityControlling,
        hapticsAudioService: HapticsAudioServicing,
        persistenceService: PersistenceServicing
    ) {
        self.engine = engine
        self.notificationService = notificationService
        self.liveActivityService = liveActivityService
        self.hapticsAudioService = hapticsAudioService
        self.persistenceService = persistenceService

        self.engine.onSnapshot = { [weak self] snapshot in
            Task { @MainActor in
                self?.handleSnapshot(snapshot)
            }
        }
        restoreTimerIfNeeded()
    }

    var progress: Double {
        guard snapshot.configuredDuration > 0 else { return 0 }
        return max(0, min(1, 1 - snapshot.remainingSeconds / snapshot.configuredDuration))
    }

    var formattedRemaining: String {
        Self.formatDuration(snapshot.remainingSeconds)
    }

    func requestNotificationPermissionIfNeeded() {
        Task {
            let status = await notificationService.currentAuthorizationStatus()
            if status == .notDetermined {
                _ = await notificationService.requestAuthorization()
            }
            await updateNotificationBanner()
        }
    }

    func startPreset(_ duration: TimeInterval) {
        start(duration: duration)
    }

    func startCustomMinutes() {
        guard
            let minutes = Double(customMinutes.replacingOccurrences(of: ",", with: ".")),
            minutes > 0
        else { return }
        start(duration: minutes * 60)
    }

    func toggleRunPause() {
        switch snapshot.state {
        case .idle, .finished:
            startPreset(presets[1])
        case .running:
            engine.pause()
            Task {
                await notificationService.cancelTimerNotification()
                await liveActivityService.endTimerActivity()
                persistSnapshot()
            }
        case .paused:
            engine.resume()
            Task {
                if let endDate = engine.snapshot.endDate {
                    await notificationService.scheduleTimerFinishedNotification(at: endDate)
                    await liveActivityService.startTimerActivity(
                        endDate: endDate,
                        remaining: engine.snapshot.remainingSeconds,
                        total: engine.snapshot.configuredDuration
                    )
                }
                persistSnapshot()
            }
        }
    }

    func reset() {
        engine.reset()
        Task {
            await notificationService.cancelTimerNotification()
            await liveActivityService.endTimerActivity()
        }
        persistenceService.clearTimer()
    }

    func sceneDidBecomeActive() {
        if snapshot.state == .running, let endDate = snapshot.endDate {
            Task {
                await liveActivityService.updateTimerActivity(
                    endDate: endDate,
                    remaining: snapshot.remainingSeconds,
                    total: snapshot.configuredDuration
                )
            }
        }
    }

    private func start(duration: TimeInterval) {
        engine.start(duration: duration)
        requestNotificationPermissionIfNeeded()

        Task {
            if let endDate = engine.snapshot.endDate {
                await notificationService.scheduleTimerFinishedNotification(at: endDate)
                await liveActivityService.startTimerActivity(
                    endDate: endDate,
                    remaining: engine.snapshot.remainingSeconds,
                    total: engine.snapshot.configuredDuration
                )
                persistSnapshot()
            }
        }
    }

    private func handleSnapshot(_ newSnapshot: TimerSnapshot) {
        snapshot = newSnapshot

        if newSnapshot.state == .running, let endDate = newSnapshot.endDate {
            let sec = Int(newSnapshot.remainingSeconds.rounded())
            if sec != lastLiveActivitySecond {
                lastLiveActivitySecond = sec
                Task {
                    await liveActivityService.updateTimerActivity(
                        endDate: endDate,
                        remaining: newSnapshot.remainingSeconds,
                        total: newSnapshot.configuredDuration
                    )
                    persistSnapshot()
                }
            }
        }

        if newSnapshot.state == .finished {
            hapticsAudioService.playTimerFinishedFeedback()
            persistenceService.clearTimer()
            Task {
                await liveActivityService.endTimerActivity()
                await notificationService.cancelTimerNotification()
            }
        }
    }

    private func restoreTimerIfNeeded() {
        guard let saved = persistenceService.loadTimer() else { return }
        engine.restore(
            configuredDuration: saved.configuredDuration,
            endDate: saved.endDate,
            wasRunning: saved.isRunning
        )
    }

    private func persistSnapshot() {
        persistenceService.saveTimer(
            configuredDuration: snapshot.configuredDuration,
            endDate: snapshot.endDate,
            isRunning: snapshot.state == .running
        )
    }

    private func updateNotificationBanner() async {
        let status = await notificationService.currentAuthorizationStatus()
        if status == .authorized || status == .provisional {
            showNotificationBanner = false
            return
        }
        showNotificationBanner = true
        notificationStatusText = "Notifications désactivées. Active-les dans Réglages pour les alertes en arrière-plan."
    }

    static func formatDuration(_ duration: TimeInterval) -> String {
        let total = max(0, Int(duration.rounded()))
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

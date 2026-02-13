import Foundation

@MainActor
final class TimerEngine: TimerControlling {
    private var tickTimer: Timer?
    private var pausedRemaining: TimeInterval = 0

    private(set) var snapshot: TimerSnapshot = .empty {
        didSet { onSnapshot?(snapshot) }
    }

    var onSnapshot: ((TimerSnapshot) -> Void)?

    deinit {
        tickTimer?.invalidate()
    }

    func start(duration: TimeInterval) {
        guard duration > 0 else { return }
        let now = Date()
        let endDate = now.addingTimeInterval(duration)

        pausedRemaining = duration
        snapshot = TimerSnapshot(
            state: .running,
            configuredDuration: duration,
            remainingSeconds: duration,
            endDate: endDate
        )
        startTicking()
    }

    func pause() {
        guard snapshot.state == .running, let endDate = snapshot.endDate else { return }
        pausedRemaining = max(0, endDate.timeIntervalSinceNow)
        stopTicking()
        snapshot.state = .paused
        snapshot.remainingSeconds = pausedRemaining
        snapshot.endDate = nil
    }

    func resume() {
        guard snapshot.state == .paused, pausedRemaining > 0 else { return }
        let endDate = Date().addingTimeInterval(pausedRemaining)
        snapshot.state = .running
        snapshot.endDate = endDate
        startTicking()
    }

    func reset() {
        stopTicking()
        pausedRemaining = 0
        snapshot = .empty
    }

    func restore(configuredDuration: TimeInterval, endDate: Date, wasRunning: Bool) {
        guard configuredDuration > 0 else {
            reset()
            return
        }

        let remaining = max(0, endDate.timeIntervalSinceNow)
        if remaining == 0 {
            snapshot = TimerSnapshot(
                state: .finished,
                configuredDuration: configuredDuration,
                remainingSeconds: 0,
                endDate: nil
            )
            return
        }

        pausedRemaining = remaining
        snapshot = TimerSnapshot(
            state: wasRunning ? .running : .paused,
            configuredDuration: configuredDuration,
            remainingSeconds: remaining,
            endDate: wasRunning ? endDate : nil
        )

        if wasRunning {
            startTicking()
        }
    }

    private func startTicking() {
        stopTicking()
        tickTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            self?.tick()
        }
        if let tickTimer {
            RunLoop.main.add(tickTimer, forMode: .common)
        }
    }

    private func stopTicking() {
        tickTimer?.invalidate()
        tickTimer = nil
    }

    private func tick() {
        guard snapshot.state == .running, let endDate = snapshot.endDate else { return }
        let remaining = max(0, endDate.timeIntervalSinceNow)
        snapshot.remainingSeconds = remaining
        if remaining == 0 {
            stopTicking()
            snapshot.state = .finished
            snapshot.endDate = nil
        }
    }
}

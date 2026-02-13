import Foundation

@MainActor
final class StopwatchEngine: StopwatchControlling {
    private var timer: Timer?
    private var startedAt: Date?
    private var accumulated: TimeInterval = 0

    private(set) var snapshot: StopwatchSnapshot = .empty {
        didSet { onSnapshot?(snapshot) }
    }

    var onSnapshot: ((StopwatchSnapshot) -> Void)?

    deinit {
        timer?.invalidate()
    }

    func start() {
        guard snapshot.state == .idle else { return }
        startedAt = Date()
        snapshot.state = .running
        beginTicking()
    }

    func pause() {
        guard snapshot.state == .running, let startedAt else { return }
        accumulated += Date().timeIntervalSince(startedAt)
        self.startedAt = nil
        snapshot.state = .paused
        snapshot.elapsed = accumulated
        timer?.invalidate()
        timer = nil
    }

    func resume() {
        guard snapshot.state == .paused else { return }
        startedAt = Date()
        snapshot.state = .running
        beginTicking()
    }

    func reset() {
        timer?.invalidate()
        timer = nil
        startedAt = nil
        accumulated = 0
        snapshot = .empty
    }

    func lap() {
        guard snapshot.state == .running else { return }
        let current = currentElapsed()
        let previousTotal = snapshot.laps.first?.totalElapsed ?? 0
        let lapTime = current - previousTotal
        let nextIndex = (snapshot.laps.first?.index ?? 0) + 1
        let newLap = Lap(index: nextIndex, lapTime: lapTime, totalElapsed: current)
        snapshot.laps.insert(newLap, at: 0)
    }

    private func beginTicking() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.snapshot.elapsed = self.currentElapsed()
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func currentElapsed() -> TimeInterval {
        let runningPart: TimeInterval
        if let startedAt {
            runningPart = Date().timeIntervalSince(startedAt)
        } else {
            runningPart = 0
        }
        return accumulated + runningPart
    }
}

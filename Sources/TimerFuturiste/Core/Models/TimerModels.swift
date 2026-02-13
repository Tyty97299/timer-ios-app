import Foundation

enum TimerState: String, Codable {
    case idle
    case running
    case paused
    case finished
}

struct TimerSnapshot: Equatable {
    var state: TimerState
    var configuredDuration: TimeInterval
    var remainingSeconds: TimeInterval
    var endDate: Date?

    static let empty = TimerSnapshot(
        state: .idle,
        configuredDuration: 0,
        remainingSeconds: 0,
        endDate: nil
    )
}

@MainActor
protocol TimerControlling: AnyObject {
    var snapshot: TimerSnapshot { get }
    var onSnapshot: ((TimerSnapshot) -> Void)? { get set }
    func start(duration: TimeInterval)
    func pause()
    func resume()
    func reset()
    func restore(configuredDuration: TimeInterval, endDate: Date, wasRunning: Bool)
}

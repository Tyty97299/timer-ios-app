import Foundation

enum StopwatchState: String {
    case idle
    case running
    case paused
}

struct Lap: Identifiable, Equatable {
    let id = UUID()
    let index: Int
    let lapTime: TimeInterval
    let totalElapsed: TimeInterval
}

struct StopwatchSnapshot: Equatable {
    var state: StopwatchState
    var elapsed: TimeInterval
    var laps: [Lap]

    static let empty = StopwatchSnapshot(state: .idle, elapsed: 0, laps: [])
}

@MainActor
protocol StopwatchControlling: AnyObject {
    var snapshot: StopwatchSnapshot { get }
    var onSnapshot: ((StopwatchSnapshot) -> Void)? { get set }
    func start()
    func pause()
    func resume()
    func reset()
    func lap()
}

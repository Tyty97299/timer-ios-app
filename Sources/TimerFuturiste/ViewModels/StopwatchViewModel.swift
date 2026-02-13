import Foundation

@MainActor
final class StopwatchViewModel: ObservableObject {
    @Published private(set) var snapshot: StopwatchSnapshot = .empty

    private let engine: StopwatchControlling

    init(engine: StopwatchControlling) {
        self.engine = engine
        self.engine.onSnapshot = { [weak self] snapshot in
            Task { @MainActor in
                self?.snapshot = snapshot
            }
        }
    }

    var formattedElapsed: String {
        let centiseconds = Int((snapshot.elapsed * 100).rounded())
        let minutes = centiseconds / 6000
        let seconds = (centiseconds % 6000) / 100
        let cs = centiseconds % 100
        return String(format: "%02d:%02d.%02d", minutes, seconds, cs)
    }

    func primaryAction() {
        switch snapshot.state {
        case .idle:
            engine.start()
        case .running:
            engine.pause()
        case .paused:
            engine.resume()
        }
    }

    func lap() {
        engine.lap()
    }

    func reset() {
        engine.reset()
    }
}


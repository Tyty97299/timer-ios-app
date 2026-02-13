import XCTest
@testable import TimerFuturiste

@MainActor
final class TimerEngineTests: XCTestCase {
    func testStartPauseResumeResetFlow() async throws {
        let engine = TimerEngine()
        engine.start(duration: 1.5)
        XCTAssertEqual(engine.snapshot.state, .running)
        XCTAssertGreaterThan(engine.snapshot.remainingSeconds, 1.0)

        engine.pause()
        XCTAssertEqual(engine.snapshot.state, .paused)
        let paused = engine.snapshot.remainingSeconds
        XCTAssertGreaterThan(paused, 0)

        engine.resume()
        XCTAssertEqual(engine.snapshot.state, .running)

        engine.reset()
        XCTAssertEqual(engine.snapshot, .empty)
    }

    func testFinishAfterElapsedTime() async throws {
        let engine = TimerEngine()
        engine.start(duration: 0.2)

        try await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertEqual(engine.snapshot.state, .finished)
        XCTAssertEqual(engine.snapshot.remainingSeconds, 0, accuracy: 0.05)
    }

    func testRestoreRunningTimerUsesAbsoluteEndDate() async throws {
        let engine = TimerEngine()
        let endDate = Date().addingTimeInterval(1.2)

        engine.restore(configuredDuration: 5, endDate: endDate, wasRunning: true)
        XCTAssertEqual(engine.snapshot.state, .running)

        try await Task.sleep(nanoseconds: 900_000_000)
        XCTAssertLessThan(engine.snapshot.remainingSeconds, 0.6)
    }
}


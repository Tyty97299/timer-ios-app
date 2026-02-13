import XCTest
@testable import TimerFuturiste

@MainActor
final class StopwatchEngineTests: XCTestCase {
    func testStartPauseResumeAndReset() async throws {
        let engine = StopwatchEngine()
        engine.start()
        XCTAssertEqual(engine.snapshot.state, .running)

        try await Task.sleep(nanoseconds: 120_000_000)
        engine.pause()
        let pausedElapsed = engine.snapshot.elapsed
        XCTAssertEqual(engine.snapshot.state, .paused)
        XCTAssertGreaterThan(pausedElapsed, 0.05)

        engine.resume()
        XCTAssertEqual(engine.snapshot.state, .running)
        try await Task.sleep(nanoseconds: 80_000_000)
        engine.pause()
        XCTAssertGreaterThan(engine.snapshot.elapsed, pausedElapsed)

        engine.reset()
        XCTAssertEqual(engine.snapshot.state, .idle)
        XCTAssertEqual(engine.snapshot.elapsed, 0, accuracy: 0.001)
        XCTAssertTrue(engine.snapshot.laps.isEmpty)
    }

    func testLapOrderingAndValues() async throws {
        let engine = StopwatchEngine()
        engine.start()

        try await Task.sleep(nanoseconds: 100_000_000)
        engine.lap()
        try await Task.sleep(nanoseconds: 100_000_000)
        engine.lap()
        engine.pause()

        XCTAssertEqual(engine.snapshot.laps.count, 2)
        XCTAssertEqual(engine.snapshot.laps.first?.index, 2)
        XCTAssertGreaterThan(engine.snapshot.laps[0].lapTime, 0.05)
        XCTAssertGreaterThan(engine.snapshot.laps[0].totalElapsed, engine.snapshot.laps[1].totalElapsed)
    }
}


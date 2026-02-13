import XCTest

final class TimerFuturisteUITests: XCTestCase {
    func testTabsAndPrimaryActionsExist() throws {
        let app = XCUIApplication()
        app.launchArguments.append("UI_TESTING")
        app.launch()

        XCTAssertTrue(app.tabBars.buttons["Minuteur"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.tabBars.buttons["Chrono"].exists)

        XCTAssertTrue(app.buttons["Démarrer"].exists || app.buttons["Pause"].exists)

        app.tabBars.buttons["Chrono"].tap()
        XCTAssertTrue(app.buttons["Tour"].waitForExistence(timeout: 2))
    }
}


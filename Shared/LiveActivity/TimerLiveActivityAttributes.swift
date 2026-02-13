import ActivityKit
import Foundation

struct TimerLiveActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var endDate: Date
        var remainingSeconds: TimeInterval
        var totalSeconds: TimeInterval
    }

    var title: String
}

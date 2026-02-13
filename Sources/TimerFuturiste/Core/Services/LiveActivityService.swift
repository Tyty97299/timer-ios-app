import ActivityKit
import Foundation

protocol LiveActivityControlling {
    func startTimerActivity(endDate: Date, remaining: TimeInterval, total: TimeInterval) async
    func updateTimerActivity(endDate: Date, remaining: TimeInterval, total: TimeInterval) async
    func endTimerActivity() async
}

final class LiveActivityService: LiveActivityControlling {
    private var activity: Activity<TimerLiveActivityAttributes>?

    func startTimerActivity(endDate: Date, remaining: TimeInterval, total: TimeInterval) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        let attributes = TimerLiveActivityAttributes(title: "Minuteur")
        let contentState = TimerLiveActivityAttributes.ContentState(
            endDate: endDate,
            remainingSeconds: remaining,
            totalSeconds: total
        )
        do {
            activity = try Activity<TimerLiveActivityAttributes>.request(
                attributes: attributes,
                content: .init(state: contentState, staleDate: endDate),
                pushType: nil
            )
        } catch {
            activity = nil
        }
    }

    func updateTimerActivity(endDate: Date, remaining: TimeInterval, total: TimeInterval) async {
        guard let activity else { return }
        let contentState = TimerLiveActivityAttributes.ContentState(
            endDate: endDate,
            remainingSeconds: remaining,
            totalSeconds: total
        )
        await activity.update(.init(state: contentState, staleDate: endDate))
    }

    func endTimerActivity() async {
        guard let activity else { return }
        await activity.end(dismissalPolicy: .immediate)
        self.activity = nil
    }
}

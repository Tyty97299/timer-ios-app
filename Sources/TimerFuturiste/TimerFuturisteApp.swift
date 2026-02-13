import SwiftUI

@main
struct TimerFuturisteApp: App {
    @StateObject private var timerViewModel = TimerViewModel(
        engine: TimerEngine(),
        notificationService: NotificationService(),
        liveActivityService: LiveActivityService(),
        hapticsAudioService: HapticsAudioService(),
        persistenceService: PersistenceService()
    )
    @StateObject private var stopwatchViewModel = StopwatchViewModel(engine: StopwatchEngine())

    var body: some Scene {
        WindowGroup {
            RootTabView(timerViewModel: timerViewModel, stopwatchViewModel: stopwatchViewModel)
        }
    }
}


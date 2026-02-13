import SwiftUI

struct RootTabView: View {
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var timerViewModel: TimerViewModel
    @ObservedObject var stopwatchViewModel: StopwatchViewModel

    var body: some View {
        TabView {
            TimerView(viewModel: timerViewModel)
                .tabItem {
                    Label("Minuteur", systemImage: "timer")
                }

            StopwatchView(viewModel: stopwatchViewModel)
                .tabItem {
                    Label("Chrono", systemImage: "stopwatch")
                }
        }
        .tint(AppTheme.accent)
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                timerViewModel.sceneDidBecomeActive()
            }
        }
    }
}


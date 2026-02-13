import ActivityKit
import SwiftUI
import WidgetKit

struct TimerLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerLiveActivityAttributes.self) { context in
            lockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label("Minuteur", systemImage: "timer")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.endDate, style: .timer)
                        .monospacedDigit()
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("Temps restant")
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressView(
                        value: context.state.remainingSeconds,
                        total: max(context.state.totalSeconds, 1)
                    )
                    .tint(.cyan)
                }
            } compactLeading: {
                Image(systemName: "timer")
            } compactTrailing: {
                Text(context.state.endDate, style: .timer)
                    .monospacedDigit()
            } minimal: {
                Image(systemName: "timer")
            }
            .keylineTint(.cyan)
        }
    }

    @ViewBuilder
    private func lockScreenView(context: ActivityViewContext<TimerLiveActivityAttributes>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(context.attributes.title)
                    .font(.headline)
                Text("Fin prévue")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(context.state.endDate, style: .timer)
                .font(.title2.bold())
                .monospacedDigit()
        }
        .padding(16)
        .activityBackgroundTint(Color.white)
        .activitySystemActionForegroundColor(.cyan)
    }
}

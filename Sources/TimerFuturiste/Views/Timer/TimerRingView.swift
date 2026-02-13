import SwiftUI

struct TimerRingView: View {
    let progress: Double
    let text: String
    let isRunning: Bool

    @State private var pulse = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.accent.opacity(0.12), lineWidth: 18)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [AppTheme.accentGlow, AppTheme.accent],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: AppTheme.accentGlow.opacity(0.45), radius: 10)
                .animation(.easeInOut(duration: 0.25), value: progress)

            VStack(spacing: 6) {
                Text("Temps restant")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(AppTheme.textSecondary)

                Text(text)
                    .font(.system(size: 48, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(AppTheme.textPrimary)
                    .scaleEffect(isRunning && pulse ? 1.02 : 1.0)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulse)
            }
        }
        .onAppear {
            pulse = isRunning
        }
        .onChange(of: isRunning) { _, newValue in
            pulse = newValue
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Temps restant \(text)")
    }
}


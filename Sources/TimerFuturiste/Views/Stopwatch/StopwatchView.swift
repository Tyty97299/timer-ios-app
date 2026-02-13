import SwiftUI

struct StopwatchView: View {
    @ObservedObject var viewModel: StopwatchViewModel

    var body: some View {
        ZStack {
            FuturisticBackground()

            VStack(spacing: 18) {
                header
                timePanel
                controlPanel
                lapsPanel
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Chronomètre")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(AppTheme.textPrimary)

            Text("Précision centiseconde, tours instantanés.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frostedCard()
    }

    private var timePanel: some View {
        VStack(spacing: 8) {
            Text(viewModel.formattedElapsed)
                .font(.system(size: 54, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(AppTheme.textPrimary)
                .accessibilityLabel("Temps écoulé \(viewModel.formattedElapsed)")
        }
        .frame(maxWidth: .infinity)
        .frostedCard()
    }

    private var controlPanel: some View {
        HStack(spacing: 12) {
            Button(primaryTitle) {
                viewModel.primaryAction()
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.accent)
            .frame(maxWidth: .infinity)
            .accessibilityLabel(primaryTitle)

            Button("Tour") {
                viewModel.lap()
            }
            .buttonStyle(.bordered)
            .tint(AppTheme.textSecondary)
            .frame(maxWidth: .infinity)
            .disabled(viewModel.snapshot.state != .running)
            .accessibilityLabel("Ajouter un tour")

            Button("Reset") {
                viewModel.reset()
            }
            .buttonStyle(.bordered)
            .tint(AppTheme.textSecondary)
            .frame(maxWidth: .infinity)
            .accessibilityLabel("Réinitialiser")
        }
        .font(.headline.weight(.semibold))
        .frostedCard()
    }

    private var lapsPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tours")
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            if viewModel.snapshot.laps.isEmpty {
                Text("Aucun tour enregistré.")
                    .foregroundStyle(AppTheme.textSecondary)
                    .font(.subheadline)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.snapshot.laps) { lap in
                            HStack {
                                Text("Tour \(lap.index)")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(AppTheme.textPrimary)
                                Spacer()
                                Text(TimerViewModel.formatDuration(lap.lapTime))
                                    .font(.subheadline.monospacedDigit())
                                    .foregroundStyle(AppTheme.textSecondary)
                                Text(viewModelElapsedLabel(for: lap.totalElapsed))
                                    .font(.subheadline.monospacedDigit())
                                    .foregroundStyle(AppTheme.accent)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
                .frame(maxHeight: 240)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frostedCard()
    }

    private var primaryTitle: String {
        switch viewModel.snapshot.state {
        case .idle:
            return "Démarrer"
        case .running:
            return "Pause"
        case .paused:
            return "Reprendre"
        }
    }

    private func viewModelElapsedLabel(for duration: TimeInterval) -> String {
        let centiseconds = Int((duration * 100).rounded())
        let minutes = centiseconds / 6000
        let seconds = (centiseconds % 6000) / 100
        let cs = centiseconds % 100
        return String(format: "%02d:%02d.%02d", minutes, seconds, cs)
    }
}


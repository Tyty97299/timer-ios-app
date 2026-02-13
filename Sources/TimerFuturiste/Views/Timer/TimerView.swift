import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel

    var body: some View {
        ZStack {
            FuturisticBackground()

            ScrollView {
                VStack(spacing: 20) {
                    header
                    ringSection
                    presetsSection
                    customSection
                    controlsSection
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
        }
        .onAppear {
            viewModel.requestNotificationPermissionIfNeeded()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Minuteur")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(AppTheme.textPrimary)

            Text("Interface claire, suivi précis, alertes en arrière-plan.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)

            if viewModel.showNotificationBanner {
                Text(viewModel.notificationStatusText)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppTheme.accent.opacity(0.92), in: RoundedRectangle(cornerRadius: 12))
                    .accessibilityLabel("Alerte notifications désactivées")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frostedCard()
    }

    private var ringSection: some View {
        VStack(spacing: 16) {
            TimerRingView(
                progress: viewModel.progress,
                text: viewModel.formattedRemaining,
                isRunning: viewModel.snapshot.state == .running
            )
            .frame(height: 260)
        }
        .frostedCard()
    }

    private var presetsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Presets")
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            HStack(spacing: 10) {
                ForEach(viewModel.presets, id: \.self) { preset in
                    Button(action: {
                        viewModel.startPreset(preset)
                    }) {
                        Text(label(for: preset))
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(AppTheme.accent)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 12))
                    }
                    .accessibilityLabel("Preset \(label(for: preset))")
                }
            }
        }
        .frostedCard()
    }

    private var customSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Durée personnalisée")
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            HStack(spacing: 10) {
                TextField("Minutes", text: $viewModel.customMinutes)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel("Minutes personnalisées")

                Button("Lancer") {
                    viewModel.startCustomMinutes()
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.accent)
            }
        }
        .frostedCard()
    }

    private var controlsSection: some View {
        HStack(spacing: 12) {
            Button(action: { viewModel.toggleRunPause() }) {
                Text(primaryButtonTitle)
                    .font(.headline.weight(.bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.accent)
            .accessibilityLabel(primaryButtonTitle)

            Button(action: { viewModel.reset() }) {
                Text("Reset")
                    .font(.headline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.bordered)
            .tint(AppTheme.textSecondary)
            .accessibilityLabel("Réinitialiser")
        }
        .frostedCard()
    }

    private var primaryButtonTitle: String {
        switch viewModel.snapshot.state {
        case .idle, .finished:
            return "Démarrer"
        case .running:
            return "Pause"
        case .paused:
            return "Reprendre"
        }
    }

    private func label(for preset: TimeInterval) -> String {
        let minutes = Int(preset / 60)
        return "\(minutes)m"
    }
}


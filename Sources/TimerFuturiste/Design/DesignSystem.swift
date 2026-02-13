import SwiftUI

enum AppTheme {
    static let backgroundTop = Color(red: 0.95, green: 0.98, blue: 1.0)
    static let backgroundBottom = Color(red: 0.90, green: 0.95, blue: 1.0)
    static let card = Color.white.opacity(0.75)
    static let stroke = Color.white.opacity(0.9)
    static let accent = Color(red: 0.02, green: 0.56, blue: 0.98)
    static let accentGlow = Color(red: 0.21, green: 0.80, blue: 1.0)
    static let textPrimary = Color(red: 0.06, green: 0.12, blue: 0.22)
    static let textSecondary = Color(red: 0.28, green: 0.36, blue: 0.5)
}

struct FrostedCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(AppTheme.stroke, lineWidth: 1)
            )
            .shadow(color: AppTheme.accentGlow.opacity(0.18), radius: 18, x: 0, y: 10)
    }
}

extension View {
    func frostedCard() -> some View {
        modifier(FrostedCard())
    }
}

struct FuturisticBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [AppTheme.backgroundTop, AppTheme.backgroundBottom], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            Circle()
                .fill(AppTheme.accent.opacity(0.12))
                .frame(width: 260, height: 260)
                .blur(radius: 10)
                .offset(x: -120, y: -280)

            Circle()
                .fill(AppTheme.accentGlow.opacity(0.15))
                .frame(width: 220, height: 220)
                .blur(radius: 6)
                .offset(x: 130, y: 320)
        }
    }
}


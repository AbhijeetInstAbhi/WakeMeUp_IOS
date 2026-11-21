import SwiftUI

public struct AppLogoView: View {
    public var size: CGFloat
    public var showText: Bool

    @State private var animatePulse = false

    public init(size: CGFloat = 48, showText: Bool = true) {
        self.size = size
        self.showText = showText
    }

    public var body: some View {
        HStack(spacing: 10) {
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color(red: 0.22, green: 0.74, blue: 0.97), Color(red: 0.01, green: 0.52, blue: 0.78)],
                            center: .center,
                            startRadius: 0,
                            endRadius: size / 2
                        )
                    )
                    .frame(width: size, height: size)
                    .scaleEffect(animatePulse ? 1.08 : 0.95)
                    .animation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animatePulse)

                Image(systemName: "location.fill")
                    .font(.system(size: size * 0.55, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: size, height: size)

                Image(systemName: "bell.badge.fill")
                    .font(.system(size: size * 0.35, weight: .bold))
                    .foregroundColor(Color(red: 0.96, green: 0.62, blue: 0.04))
                    .offset(x: 4, y: -4)
            }

            if showText {
                Text("WakeMeUp")
                    .font(.system(size: size * 0.45, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            animatePulse = true
        }
    }
}

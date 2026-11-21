import SwiftUI

public struct SplashScreenView: View {
    public var onFinished: (() -> Void)?

    @State private var wave1Scale: CGFloat = 0.2
    @State private var wave1Alpha: Double = 0.7
    @State private var wave2Scale: CGFloat = 0.2
    @State private var wave2Alpha: Double = 0.7
    @State private var pinScale: CGFloat = 0.92

    public init(onFinished: (() -> Void)? = nil) {
        self.onFinished = onFinished
    }

    public var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.03, green: 0.08, blue: 0.15), Color(red: 0.04, green: 0.15, blue: 0.27), Color(red: 0.07, green: 0.25, blue: 0.45)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                ZStack {
                    Circle()
                        .stroke(Color(red: 0.22, green: 0.74, blue: 0.97).opacity(wave1Alpha), lineWidth: 3)
                        .frame(width: 220, height: 220)
                        .scaleEffect(wave1Scale)

                    Circle()
                        .stroke(Color(red: 0.38, green: 0.65, blue: 0.98).opacity(wave2Alpha), lineWidth: 3)
                        .frame(width: 220, height: 220)
                        .scaleEffect(wave2Scale)

                    Circle()
                        .fill(RadialGradient(colors: [Color.blue.opacity(0.6), Color.blue.opacity(0.1)], center: .center, startRadius: 0, endRadius: 60))
                        .frame(width: 120, height: 120)

                    Image(systemName: "location.fill")
                        .font(.system(size: 64, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(pinScale)
                }
                .frame(width: 220, height: 220)

                Spacer().frame(height: 24)

                AppLogoView(size: 54, showText: true)

                Text("Never miss your stop again")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.85))
                    .padding(.top, 8)

                Spacer()

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 0.22, green: 0.74, blue: 0.97)))
                    .padding(.bottom, 8)

                Text("Initializing GPS Engine...")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.7))

                Spacer().frame(height: 40)
            }
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 2.2).repeatForever(autoreverses: false)) {
                wave1Scale = 1.3
                wave1Alpha = 0.0
            }

            withAnimation(Animation.linear(duration: 2.2).delay(1.1).repeatForever(autoreverses: false)) {
                wave2Scale = 1.3
                wave2Alpha = 0.0
            }

            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                pinScale = 1.12
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                onFinished?()
            }
        }
    }
}

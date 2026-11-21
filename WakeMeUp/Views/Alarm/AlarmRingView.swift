import SwiftUI

public struct AlarmRingView: View {
    public var placeName: String
    public var radiusMeters: Int
    public var snoozeMinutes: Int
    public var onStop: () -> Void
    public var onSnooze: () -> Void

    @State private var pulseScale: CGFloat = 0.9

    public var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.04, green: 0.04, blue: 0.08), Color(red: 0.09, green: 0.07, blue: 0.21), Color(red: 0.04, green: 0.04, blue: 0.08)],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 48)

                Text("Wake Up!")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)

                Text("You are near your stop")
                    .font(.system(size: 18))
                    .foregroundColor(Color.white.opacity(0.85))
                    .padding(.top, 12)

                Text(placeName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(red: 0.39, green: 0.40, blue: 0.95))
                    .padding(.top, 4)

                if radiusMeters > 0 {
                    Text("within \(radiusMeters / 1000) km radius")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.6))
                        .padding(.top, 4)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(Color(red: 0.39, green: 0.40, blue: 0.95).opacity(0.18))
                        .frame(width: 180, height: 180)
                        .scaleEffect(pulseScale)

                    ZStack {
                        Circle()
                            .fill(Color(red: 0.39, green: 0.40, blue: 0.95))
                            .frame(width: 120, height: 120)

                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: 56, weight: .bold))
                            .foregroundColor(.white)
                    }
                }

                Spacer()

                VStack(spacing: 12) {
                    Button(action: onStop) {
                        Text("Stop Alarm")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(red: 0.39, green: 0.40, blue: 0.95))
                            .cornerRadius(16)
                    }

                    Button(action: onSnooze) {
                        Text("Snooze (\(snoozeMinutes) min)")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white.opacity(0.85))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                pulseScale = 1.15
            }
        }
    }
}

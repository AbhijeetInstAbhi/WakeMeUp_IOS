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
                colors: [
                    Color(red: 0.043, green: 0.043, blue: 0.078),
                    Color(red: 0.090, green: 0.071, blue: 0.208),
                    Color(red: 0.043, green: 0.043, blue: 0.078)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 48)

                Text("Wake Up!")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)

                Text("You are near your stop")
                    .font(.system(size: 18))
                    .foregroundColor(Color.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)

                Text(placeName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97)) // ElectricBlue #38BDF8
                    .padding(.top, 4)

                if radiusMeters > 0 {
                    Text("within \(radiusMeters / 1000) km radius")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.6))
                        .padding(.top, 4)
                }

                Spacer()

                // Pulsing Radar Center
                ZStack {
                    Circle()
                        .fill(Color(red: 0.22, green: 0.74, blue: 0.97).opacity(0.18))
                        .frame(width: 180, height: 180)
                        .scaleEffect(pulseScale)

                    ZStack {
                        Circle()
                            .fill(Color(red: 0.22, green: 0.74, blue: 0.97)) // ElectricBlue
                            .frame(width: 120, height: 120)

                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: 56, weight: .bold))
                            .foregroundColor(.white)
                    }
                }

                Spacer()

                VStack(spacing: 10) {
                    Button(action: onStop) {
                        Text("Stop Alarm")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(red: 0.22, green: 0.74, blue: 0.97))
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

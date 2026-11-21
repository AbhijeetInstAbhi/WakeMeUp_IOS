import SwiftUI

public struct TripCompletedView: View {
    @ObservedObject var locationManager = LocationManager.shared

    public var onBackHome: () -> Void
    public var onNewAlarm: () -> Void

    @State private var scaleCheck = false

    public var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.11, blue: 0.16), Color(red: 0.11, green: 0.15, blue: 0.23)],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(Color(red: 0.06, green: 0.73, blue: 0.51).opacity(0.15))
                        .frame(width: 130, height: 130)

                    Circle()
                        .fill(Color(red: 0.06, green: 0.73, blue: 0.51).opacity(0.3))
                        .frame(width: 100, height: 100)

                    Circle()
                        .fill(Color(red: 0.06, green: 0.73, blue: 0.51))
                        .frame(width: 72, height: 72)

                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(scaleCheck ? 1.0 : 0.3)
                .animation(.spring(response: 0.6, dampingFraction: 0.6), value: scaleCheck)

                VStack(spacing: 8) {
                    Text("Trip Completed!")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)

                    Text("You have safely arrived at your destination.")
                        .font(.system(size: 16))
                        .foregroundColor(Color.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                }

                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.06, green: 0.73, blue: 0.51).opacity(0.2))
                                .frame(width: 44, height: 44)
                            Image(systemName: "location.fill")
                                .foregroundColor(Color(red: 0.20, green: 0.83, blue: 0.60))
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("DESTINATION")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color.white.opacity(0.5))
                                .tracking(1)
                            Text(locationManager.destinationName.isEmpty ? "Reached Destination" : locationManager.destinationName)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            if !locationManager.destinationAddress.isEmpty {
                                Text(locationManager.destinationAddress)
                                    .font(.system(size: 13))
                                    .foregroundColor(Color.white.opacity(0.6))
                            }
                        }
                    }

                    Divider().background(Color.white.opacity(0.1))

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("ARRIVAL TIME")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color.white.opacity(0.5))
                            Text(formattedTimeString)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text("ALARM RADIUS")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color.white.opacity(0.5))
                            Text(GeoUtils.formatRadius(locationManager.radiusMeters))
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(red: 0.20, green: 0.83, blue: 0.60))
                        }
                    }

                    HStack(spacing: 10) {
                        Image(systemName: "bell.badge.fill")
                            .foregroundColor(Color(red: 0.20, green: 0.83, blue: 0.60))
                        Text("Location alarm triggered & turned off")
                            .font(.system(size: 13))
                            .foregroundColor(Color.white.opacity(0.9))
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(red: 0.06, green: 0.73, blue: 0.51).opacity(0.12))
                    .cornerRadius(12)
                }
                .padding(20)
                .background(Color.white.opacity(0.08))
                .cornerRadius(24)

                Spacer()

                VStack(spacing: 12) {
                    Button(action: onBackHome) {
                        HStack(spacing: 10) {
                            Image(systemName: "house.fill")
                            Text("Back to Home")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(red: 0.06, green: 0.73, blue: 0.51))
                        .cornerRadius(16)
                    }

                    Button(action: onNewAlarm) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                            Text("Set New Alarm")
                                .font(.system(size: 15))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.3), lineWidth: 1))
                    }
                }
            }
            .padding(24)
        }
        .onAppear {
            scaleCheck = true
        }
    }

    private var formattedTimeString: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

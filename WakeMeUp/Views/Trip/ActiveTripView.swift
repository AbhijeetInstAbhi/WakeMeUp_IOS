import SwiftUI

public struct ActiveTripView: View {
    @StateObject private var viewModel = ActiveTripViewModel()
    @ObservedObject private var locationManager = LocationManager.shared

    public var onStopTrip: () -> Void
    public var onTripCompleted: () -> Void

    @State private var animatePulse = false

    public var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.09, blue: 0.16).ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        // Header Status
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Active Trip")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Monitoring location in real-time (\(locationManager.transportMode.label))")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color.white.opacity(0.7))
                            }

                            Spacer()

                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color(red: 0.06, green: 0.73, blue: 0.51))
                                    .frame(width: 8, height: 8)
                                Text("LIVE GPS")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Color(red: 0.20, green: 0.83, blue: 0.60))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(red: 0.06, green: 0.73, blue: 0.51).opacity(0.2))
                            .cornerRadius(50)
                            .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color(red: 0.06, green: 0.73, blue: 0.51).opacity(0.5), lineWidth: 1))
                        }

                        // Pulse Radar Visualizer
                        ZStack {
                            Circle()
                                .stroke(Color(red: 0.22, green: 0.74, blue: 0.97).opacity(animatePulse ? 0.0 : 0.6), lineWidth: 3)
                                .frame(width: 150, height: 150)
                                .scaleEffect(animatePulse ? 1.4 : 0.8)

                            ZStack {
                                Circle()
                                    .fill(RadialGradient(colors: [Color(red: 0.01, green: 0.52, blue: 0.78), Color(red: 0.01, green: 0.41, blue: 0.63)], center: .center, startRadius: 0, endRadius: 45))
                                    .frame(width: 86, height: 86)

                                Image(systemName: locationManager.transportMode.iconName)
                                    .font(.system(size: 42, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(height: 150)

                        // Active Card
                        VStack(alignment: .leading, spacing: 18) {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.22, green: 0.74, blue: 0.97).opacity(0.2))
                                        .frame(width: 42, height: 42)
                                    Image(systemName: "location.fill")
                                        .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))
                                }

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(locationManager.destinationName.isEmpty ? "Active Destination" : locationManager.destinationName)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                    if !locationManager.destinationAddress.isEmpty {
                                        Text(locationManager.destinationAddress)
                                            .font(.system(size: 12))
                                            .foregroundColor(Color.white.opacity(0.6))
                                            .lineLimit(2)
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("DISTANCE REMAINING")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Color.white.opacity(0.5))
                                    .tracking(1)

                                Text(GeoUtils.formatTripDistance(locationManager.remainingDistance))
                                    .font(.system(size: 36, weight: .heavy))
                                    .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))
                            }

                            let progress = locationManager.initialDistance > 0 ? max(0, min(1, 1.0 - (locationManager.remainingDistance / locationManager.initialDistance))) : 0.5
                            ProgressView(value: progress)
                                .accentColor(Color(red: 0.22, green: 0.74, blue: 0.97))

                            HStack {
                                let eta = max(1, Int((locationManager.remainingDistance / 1000.0) / 40.0 * 60))
                                HStack(spacing: 6) {
                                    Image(systemName: "location.north.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.white.opacity(0.6))
                                    Text("ETA ~ \(eta) mins")
                                        .font(.system(size: 13))
                                        .foregroundColor(Color.white.opacity(0.8))
                                }

                                Spacer()

                                HStack(spacing: 6) {
                                    Image(systemName: "bell.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(red: 0.20, green: 0.83, blue: 0.60))
                                    Text("Alert within \(GeoUtils.formatRadius(locationManager.radiusMeters))")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(red: 0.20, green: 0.83, blue: 0.60))
                                }
                            }

                            Button(action: {
                                locationManager.triggerAlarmCompletion()
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "play.circle.fill")
                                        .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))
                                    Text("Test Alarm Ring (Simulate Arrival)")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 14)
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 0.22, green: 0.74, blue: 0.97).opacity(0.15))
                                .cornerRadius(12)
                            }
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.07))
                        .cornerRadius(24)
                    }
                    .padding(20)
                }

                // Sticky Bottom Bar
                VStack {
                    Button(action: {
                        viewModel.stopTrip()
                        onStopTrip()
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "stop.fill")
                            Text("Stop & Cancel Trip")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color(red: 0.93, green: 0.26, blue: 0.26))
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color(red: 0.06, green: 0.09, blue: 0.16))
            }

            // Direct Full-Screen Alarm Overlay over Active Trip Screen
            if locationManager.shouldRingAlarm {
                AlarmRingView(
                    placeName: locationManager.ringingAlarm?.placeName ?? (locationManager.destinationName.isEmpty ? "Destination Stop" : locationManager.destinationName),
                    radiusMeters: locationManager.ringingAlarm?.radiusMeters ?? locationManager.radiusMeters,
                    snoozeMinutes: SettingsRepository.shared.settings.defaultSnoozeMinutes,
                    onStop: {
                        AlarmSoundPlayer.shared.stop()
                        locationManager.shouldRingAlarm = false
                        onTripCompleted()
                    },
                    onSnooze: {
                        locationManager.scheduleSnooze(minutes: SettingsRepository.shared.settings.defaultSnoozeMinutes)
                        onTripCompleted()
                    }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(999)
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: false)) {
                animatePulse = true
            }
        }
    }
}

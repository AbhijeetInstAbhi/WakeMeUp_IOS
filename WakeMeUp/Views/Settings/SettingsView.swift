import SwiftUI

public struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @ObservedObject private var settingsRepo = SettingsRepository.shared

    @State private var showFeedback = false
    @State private var showSos = false

    public var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.09, blue: 0.16).ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Text("Settings & Tools")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 8)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // SECTION 1: Alarm Tools
                        SectionHeader(title: "ALARM TOOLS & AUDIO")

                        VStack(spacing: 12) {
                            SettingToggleRow(
                                title: "Vibrate on Alarm",
                                subtitle: "Vibrate phone continuously when threshold reached",
                                isOn: Binding(
                                    get: { viewModel.settings.vibrate },
                                    set: { viewModel.setVibrate($0) }
                                )
                            )

                            Divider().background(Color.white.opacity(0.1))

                            SettingToggleRow(
                                title: "Loud Volume Boost",
                                subtitle: "Override silent mode and play at max volume",
                                isOn: Binding(
                                    get: { viewModel.settings.loudAlarm },
                                    set: { viewModel.setLoud($0) }
                                )
                            )

                            Divider().background(Color.white.opacity(0.1))

                            // Default Snooze Duration
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Default Snooze Duration")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("How long snooze delays the alarm")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.white.opacity(0.6))

                                HStack(spacing: 8) {
                                    ForEach([5, 10, 15, 20], id: \.self) { mins in
                                        let isSel = viewModel.settings.defaultSnoozeMinutes == mins
                                        Button(action: { viewModel.setSnoozeMinutes(mins) }) {
                                            Text("\(mins)m")
                                                .font(.system(size: 13, weight: isSel ? .bold : .medium))
                                                .foregroundColor(isSel ? .black : .white)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 36)
                                                .background(isSel ? Color(red: 0.22, green: 0.74, blue: 0.97) : Color.white.opacity(0.08))
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                            }

                            Divider().background(Color.white.opacity(0.1))

                            // Auto-Silence Duration
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Auto-Silence Duration")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("Automatically stop ringing after duration")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.white.opacity(0.6))

                                HStack(spacing: 8) {
                                    ForEach([3, 5, 10, 0], id: \.self) { mins in
                                        let isSel = viewModel.settings.autoSilenceMinutes == mins
                                        let label = mins == 0 ? "Never" : "\(mins)m"
                                        Button(action: { viewModel.setAutoSilenceMinutes(mins) }) {
                                            Text(label)
                                                .font(.system(size: 13, weight: isSel ? .bold : .medium))
                                                .foregroundColor(isSel ? .black : .white)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 36)
                                                .background(isSel ? Color(red: 0.22, green: 0.74, blue: 0.97) : Color.white.opacity(0.08))
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                            }

                            Divider().background(Color.white.opacity(0.1))

                            Button(action: {
                                AlarmSoundPlayer.shared.start(vibrate: viewModel.settings.vibrate, loud: viewModel.settings.loudAlarm)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    AlarmSoundPlayer.shared.stop()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "speaker.wave.3.fill")
                                    Text("Test Alarm Ringtone (3s)")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.3), lineWidth: 1))
                            }
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.07))
                        .cornerRadius(18)

                        // SECTION 2: Emergency SOS
                        SectionHeader(title: "EMERGENCY & SAFETY")

                        Button(action: { showSos = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "shield.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.red)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Emergency SOS Contact")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.white)
                                    Text(settingsRepo.settings.sosContactName.isEmpty ? "Not configured · Tap to set up" : "Active: \(settingsRepo.settings.sosContactName) (\(settingsRepo.settings.sosContactPhone))")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.white.opacity(0.6))
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.white.opacity(0.4))
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.07))
                            .cornerRadius(18)
                        }

                        // SECTION 3: Feedback
                        SectionHeader(title: "SUPPORT & FEEDBACK")

                        Button(action: { showFeedback = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Send Feedback & Bug Reports")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("Help us improve WakeMeUp")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.white.opacity(0.6))
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.white.opacity(0.4))
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.07))
                            .cornerRadius(18)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .fullScreenCover(isPresented: $showFeedback) {
            FeedbackView()
        }
        .fullScreenCover(isPresented: $showSos) {
            SosConfigView()
        }
    }
}

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(Color.white.opacity(0.5))
            .tracking(1)
            .padding(.leading, 4)
    }
}

struct SettingToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.6))
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.22, green: 0.74, blue: 0.97)))
        }
    }
}

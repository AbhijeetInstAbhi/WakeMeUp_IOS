import SwiftUI

public enum BottomTab: String, CaseIterable, Identifiable {
    case home
    case history
    case settings

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .home: return "Home"
        case .history: return "History"
        case .settings: return "Settings"
        }
    }

    public var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .history: return "clock.arrow.circlepath"
        case .settings: return "gearshape.fill"
        }
    }
}

public struct MainTabView: View {
    @State private var selectedTab: BottomTab = .home
    @State private var showCreateAlarm = false
    @State private var showActiveTrip = false
    @State private var showSosConfig = false

    @ObservedObject private var locationManager = LocationManager.shared

    public var body: some View {
        ZStack {
            ZStack(alignment: .bottomTrailing) {
                TabView(selection: $selectedTab) {
                    HomeView(
                        onAddAlarm: { showCreateAlarm = true },
                        onActiveTripClick: { showActiveTrip = true }
                    )
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(BottomTab.home)

                    HistoryView()
                        .tabItem {
                            Label("History", systemImage: "clock.arrow.circlepath")
                        }
                        .tag(BottomTab.history)

                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                        .tag(BottomTab.settings)
                }
                .accentColor(Color(red: 0.22, green: 0.74, blue: 0.97))

                // Emergency SOS FAB on Home tab
                if selectedTab == .home {
                    Button(action: { showSosConfig = true }) {
                        ZStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 56, height: 56)
                                .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)

                            Image(systemName: "shield.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 70)
                }
            }

            // Top-level Alarm Ringing Screen Overlay
            if locationManager.shouldRingAlarm {
                AlarmRingView(
                    placeName: locationManager.ringingAlarm?.placeName ?? (locationManager.destinationName.isEmpty ? "Destination Stop" : locationManager.destinationName),
                    radiusMeters: locationManager.ringingAlarm?.radiusMeters ?? locationManager.radiusMeters,
                    snoozeMinutes: SettingsRepository.shared.settings.defaultSnoozeMinutes,
                    onStop: {
                        AlarmSoundPlayer.shared.stop()
                        locationManager.shouldRingAlarm = false
                        showActiveTrip = false
                    },
                    onSnooze: {
                        AlarmSoundPlayer.shared.stop()
                        locationManager.shouldRingAlarm = false
                        showActiveTrip = false
                    }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(999)
            }
        }
        .fullScreenCover(isPresented: $showCreateAlarm) {
            CreateAlarmView(
                onDone: {
                    showCreateAlarm = false
                    showActiveTrip = true
                },
                onCancel: {
                    showCreateAlarm = false
                }
            )
        }
        .fullScreenCover(isPresented: $showActiveTrip) {
            ActiveTripView(
                onStopTrip: {
                    showActiveTrip = false
                },
                onTripCompleted: {
                    showActiveTrip = false
                }
            )
        }
        .fullScreenCover(isPresented: $showSosConfig) {
            SosConfigView()
        }
    }
}

import SwiftUI

public struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject private var settingsRepo = SettingsRepository.shared

    public var onAddAlarm: () -> Void
    public var onActiveTripClick: () -> Void

    public var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.09, blue: 0.16).ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    AppLogoView(size: 36, showText: true)
                    Spacer()
                    Text("Don't miss your stop")
                        .font(.system(size: 12))
                        .foregroundColor(Color.white.opacity(0.6))
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 8)

                PermissionBannerView()

                ScrollView {
                    VStack(spacing: 16) {
                        if let active = viewModel.activeAlarm {
                            NextAlarmCardView(
                                alarm: active,
                                settings: settingsRepo.settings,
                                onClick: onActiveTripClick
                            )
                        }

                        HStack {
                            Text("WHAT YOU CAN DO")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color.white.opacity(0.5))
                                .tracking(1)

                            Spacer()

                            Text("Featured")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))
                        }
                        .padding(.top, 4)
                        .padding(.horizontal, 4)

                        FeatureCarouselView()

                        Button(action: onAddAlarm) {
                            HStack(spacing: 10) {
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .bold))
                                Text("Set New Location Alarm")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(red: 0.22, green: 0.74, blue: 0.97))
                            .cornerRadius(18)
                        }
                        .padding(.top, 8)

                        Spacer().frame(height: 80)
                    }
                    .padding(16)
                }
            }
        }
    }
}

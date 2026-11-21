import SwiftUI

@main
struct WakeMeUpApp: App {
    @ObservedObject private var settingsRepo = SettingsRepository.shared
    @State private var showSplash = true

    init() {
        // Enforce dark appearance
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(red: 0.22, green: 0.74, blue: 0.97, alpha: 1.0)
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashScreenView {
                        withAnimation {
                            showSplash = false
                        }
                    }
                } else if !settingsRepo.settings.onboardingDone {
                    OnboardingView {
                        settingsRepo.setOnboardingDone(true)
                    }
                } else {
                    MainTabView()
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

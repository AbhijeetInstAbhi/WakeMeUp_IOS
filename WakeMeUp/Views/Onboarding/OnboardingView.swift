import SwiftUI

struct OnboardingItem {
    let title: String
    let description: String
    let iconName: String
}

public struct OnboardingView: View {
    public var onFinish: () -> Void

    @State private var currentPage = 0

    private let pages = [
        OnboardingItem(
            title: "Never Miss Your Stop",
            description: "Set location-based alarms for your daily commute. WakeMeUp rings loud when you reach your target radius.",
            iconName: "location.fill"
        ),
        OnboardingItem(
            title: "Battery Friendly",
            description: "Smart adaptive GPS polling saves battery when you're far and increases precision as you get close.",
            iconName: "battery.100.bolt"
        ),
        OnboardingItem(
            title: "Rings Loud Over Silent Mode",
            description: "WakeUp alarms trigger full screen with loud sound and vibration even when your phone is locked.",
            iconName: "bell.badge.fill"
        )
    ]

    public var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.09, blue: 0.16).ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button("Skip") {
                        onFinish()
                    }
                    .foregroundColor(Color.white.opacity(0.6))
                    .padding()
                }

                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { idx in
                        let item = pages[idx]
                        VStack(spacing: 24) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.39, green: 0.40, blue: 0.95).opacity(0.15))
                                    .frame(width: 140, height: 140)

                                Image(systemName: item.iconName)
                                    .font(.system(size: 64, weight: .bold))
                                    .foregroundColor(Color(red: 0.39, green: 0.40, blue: 0.95))
                            }

                            Text(item.title)
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)

                            Text(item.description)
                                .font(.system(size: 15))
                                .foregroundColor(Color.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                        .tag(idx)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

                Spacer()

                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation { currentPage += 1 }
                    } else {
                        onFinish()
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color(red: 0.22, green: 0.74, blue: 0.97))
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}

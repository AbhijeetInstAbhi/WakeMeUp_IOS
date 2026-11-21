import SwiftUI

struct FeatureCarouselItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let badge: String
    let iconName: String
    let gradient: [Color]
}

public struct FeatureCarouselView: View {
    @State private var currentPage = 0

    private let features = [
        FeatureCarouselItem(
            title: "Bus Location Alarms",
            description: "Set proximity alerts for intercity bus stops & highway stations. Never oversleep on long rides.",
            badge: "BUS COMMUTE",
            iconName: "bus.fill",
            gradient: [Color(red: 0.01, green: 0.52, blue: 0.78), Color(red: 0.01, green: 0.41, blue: 0.63)]
        ),
        FeatureCarouselItem(
            title: "Train & Metro Station Alarms",
            description: "Rings loud before your railway station or metro stop arrival, even when your phone is locked.",
            badge: "TRAIN & METRO",
            iconName: "tram.fill",
            gradient: [Color(red: 0.39, green: 0.40, blue: 0.95), Color(red: 0.31, green: 0.27, blue: 0.90)]
        ),
        FeatureCarouselItem(
            title: "Car Commute & Highway Tracker",
            description: "Get real-time GPS distance alerts when approaching city exits, toll plazas, or landmarks.",
            badge: "CAR & DRIVE",
            iconName: "car.fill",
            gradient: [Color(red: 0.05, green: 0.58, blue: 0.53), Color(red: 0.06, green: 0.46, blue: 0.43)]
        ),
        FeatureCarouselItem(
            title: "Walking & Proximity Alerts",
            description: "Vibrates and alerts you when entering target local neighborhood spots, shops, or cafes.",
            badge: "WALKING",
            iconName: "figure.walk",
            gradient: [Color(red: 0.55, green: 0.36, blue: 0.96), Color(red: 0.43, green: 0.16, blue: 0.85)]
        ),
        FeatureCarouselItem(
            title: "Emergency SOS Protection",
            description: "Share your live location link via SMS or call your emergency contact with one tap during late trips.",
            badge: "SAFETY SOS",
            iconName: "shield.fill",
            gradient: [Color(red: 0.86, green: 0.15, blue: 0.15), Color(red: 0.60, green: 0.11, blue: 0.11)]
        )
    ]

    public var body: some View {
        VStack(spacing: 12) {
            TabView(selection: $currentPage) {
                ForEach(0..<features.count, id: \.self) { idx in
                    let item = features[idx]
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 42, height: 42)
                                Image(systemName: item.iconName)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            Text(item.badge)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color.white.opacity(0.85))
                                .tracking(1)

                            Spacer()
                        }

                        Spacer()

                        Text(item.title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)

                        Text(item.description)
                            .font(.system(size: 13))
                            .foregroundColor(Color.white.opacity(0.85))
                            .padding(.top, 4)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 200)
                    .background(LinearGradient(colors: item.gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(24)
                    .tag(idx)
                }
            }
            .frame(height: 200)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            // Indicator Dots
            HStack(spacing: 6) {
                ForEach(0..<features.count, id: \.self) { idx in
                    Circle()
                        .fill(currentPage == idx ? Color(red: 0.22, green: 0.74, blue: 0.97) : Color.white.opacity(0.3))
                        .frame(width: currentPage == idx ? 10 : 6, height: currentPage == idx ? 10 : 6)
                }
            }
        }
    }
}

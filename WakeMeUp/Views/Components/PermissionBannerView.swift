import SwiftUI
import CoreLocation

public struct PermissionBannerView: View {
    @ObservedObject var locationManager = LocationManager.shared

    public var body: some View {
        if locationManager.authorizationStatus != .authorizedAlways && locationManager.authorizationStatus != .authorizedWhenInUse {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text("Location Permission Needed")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }

                Text("WakeMeUp relies on GPS to ring your alarm when you arrive. Please set location permission to 'Always' in Settings.")
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.8))

                Button(action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Grant 'Always Allow' Permission")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color(red: 0.22, green: 0.74, blue: 0.97))
                        .cornerRadius(10)
                }
            }
            .padding(14)
            .background(Color.red.opacity(0.2))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.red.opacity(0.4), lineWidth: 1)
            )
            .padding(.horizontal, 16)
        }
    }
}

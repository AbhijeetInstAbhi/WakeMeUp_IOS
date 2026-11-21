import SwiftUI
import CoreLocation

public struct MapStepView: View {
    @ObservedObject var viewModel: CreateAlarmViewModel

    public var body: some View {
        VStack(spacing: 0) {
            MapRouteView(
                startLocation: viewModel.userLocation,
                destinationLocation: viewModel.selected?.coordinate ?? CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629),
                radiusMeters: Double(viewModel.radiusMeters),
                destinationName: viewModel.selected?.name ?? "Selected Location",
                onPointPicked: { coord in
                    viewModel.onMapPointPicked(lat: coord.latitude, lng: coord.longitude)
                }
            )

            VStack(alignment: .leading, spacing: 12) {
                Text(viewModel.selected?.name ?? "Tap map to select location")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                if let addr = viewModel.selected?.address, !addr.isEmpty {
                    Text(addr)
                        .font(.system(size: 12))
                        .foregroundColor(Color.white.opacity(0.6))
                        .lineLimit(1)
                }

                if let start = viewModel.userLocation, let dest = viewModel.selected {
                    let dist = GeoUtils.distanceMeters(lat1: start.latitude, lon1: start.longitude, lat2: dest.latitude, lon2: dest.longitude)
                    Text("Distance: \(GeoUtils.format(dist)) away")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))
                }

                HStack(spacing: 10) {
                    Button(action: { viewModel.confirmLocation() }) {
                        Text("Confirm Location")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(red: 0.22, green: 0.74, blue: 0.97))
                            .cornerRadius(14)
                    }
                    .disabled(viewModel.selected == nil)

                    if let dest = viewModel.selected {
                        Button(action: {
                            if let url = URL(string: "http://maps.apple.com/?daddr=\(dest.latitude),\(dest.longitude)") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(14)
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.3), lineWidth: 1))
                        }
                    }
                }
            }
            .padding(16)
            .background(Color(red: 0.12, green: 0.16, blue: 0.23))
            .cornerRadius(24)
        }
    }
}

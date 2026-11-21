import SwiftUI

public struct ReviewStepView: View {
    @ObservedObject var viewModel: CreateAlarmViewModel

    public var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(viewModel.selected?.name ?? "")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)

                        if let addr = viewModel.selected?.address, !addr.isEmpty {
                            Text(addr)
                                .font(.system(size: 13))
                                .foregroundColor(Color.white.opacity(0.6))
                        }

                        Divider().background(Color.white.opacity(0.1))

                        ReviewRow(label: "Alert Radius", value: GeoUtils.formatRadius(viewModel.radiusMeters))

                        if let start = viewModel.userLocation, let dest = viewModel.selected {
                            let d = GeoUtils.distanceMeters(lat1: start.latitude, lon1: start.longitude, lat2: dest.latitude, lon2: dest.longitude)
                            ReviewRow(label: "Distance", value: "\(GeoUtils.format(d)) away")
                        }

                        ReviewRow(label: "Transport Mode", value: viewModel.transportMode.label)
                        ReviewRow(label: "Snooze Duration", value: "\(viewModel.snoozeMinutes) mins")
                    }
                    .padding(18)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(20)

                    HStack(spacing: 10) {
                        if let dest = viewModel.selected {
                            Button(action: {
                                if let url = URL(string: "http://maps.apple.com/?daddr=\(dest.latitude),\(dest.longitude)") {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                HStack {
                                    Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                                    Text("Open Maps Navigation")
                                }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(14)
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.3), lineWidth: 1))
                            }
                        }
                    }
                }
                .padding(16)
            }

            VStack {
                Button(action: { viewModel.save() }) {
                    Text("Set Alarm & Start Trip")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color(red: 0.06, green: 0.73, blue: 0.51))
                        .cornerRadius(16)
                }
            }
            .padding(16)
            .background(Color(red: 0.06, green: 0.09, blue: 0.16))
        }
    }
}

struct ReviewRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label).font(.system(size: 13)).foregroundColor(Color.white.opacity(0.6))
            Spacer()
            Text(value).font(.system(size: 13, weight: .bold)).foregroundColor(.white)
        }
    }
}

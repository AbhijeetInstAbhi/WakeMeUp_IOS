import SwiftUI

public struct RadiusStepView: View {
    @ObservedObject var viewModel: CreateAlarmViewModel

    @State private var customKmText: String = ""

    private let presets = [1000, 2000, 5000, 10000]

    public var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    Text("ALERT RADIUS")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color.white.opacity(0.5))
                        .tracking(1)

                    Text(GeoUtils.formatRadius(viewModel.radiusMeters))
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))

                    Text("Alarm rings when you enter this distance threshold")
                        .font(.system(size: 12))
                        .foregroundColor(Color.white.opacity(0.7))

                    Slider(
                        value: Binding(
                            get: { Double(viewModel.radiusMeters) },
                            set: { viewModel.setRadius(Int($0)) }
                        ),
                        in: 500...50000,
                        step: 500
                    )
                    .accentColor(Color(red: 0.22, green: 0.74, blue: 0.97))

                    HStack {
                        Text("0.5 km").font(.system(size: 11)).foregroundColor(Color.white.opacity(0.5))
                        Spacer()
                        Text("50 km").font(.system(size: 11)).foregroundColor(Color.white.opacity(0.5))
                    }

                    HStack(spacing: 8) {
                        HStack(spacing: 6) {
                            ForEach(presets, id: \.self) { m in
                                let isSelected = viewModel.radiusMeters == m
                                Button(action: { viewModel.setRadius(m) }) {
                                    Text("\(m / 1000)k")
                                        .font(.system(size: 12, weight: isSelected ? .bold : .regular))
                                        .foregroundColor(isSelected ? .black : .white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 8)
                                        .background(isSelected ? Color(red: 0.22, green: 0.74, blue: 0.97) : Color.white.opacity(0.08))
                                        .cornerRadius(12)
                                }
                            }
                        }

                        Spacer()

                        HStack(spacing: 4) {
                            TextField("Custom", text: $customKmText)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .onChange(of: customKmText) { newValue in
                                    if let km = Double(newValue), km > 0 {
                                        viewModel.setRadius(Int(km * 1000))
                                    }
                                }
                            Text("km")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .frame(width: 95)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(red: 0.22, green: 0.74, blue: 0.97).opacity(0.3), lineWidth: 1))
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("SELECT TRANSPORT MODE")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color.white.opacity(0.5))
                            .tracking(1)

                        let modes = TransportMode.allCases
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                            ForEach(modes) { mode in
                                let isSelected = viewModel.transportMode == mode
                                Button(action: { viewModel.setTransportMode(mode) }) {
                                    VStack(spacing: 4) {
                                        Image(systemName: mode.iconName)
                                            .font(.system(size: 20))
                                            .foregroundColor(isSelected ? Color(red: 0.22, green: 0.74, blue: 0.97) : Color.white.opacity(0.7))
                                        Text(mode.label)
                                            .font(.system(size: 11, weight: isSelected ? .bold : .medium))
                                            .foregroundColor(isSelected ? .white : Color.white.opacity(0.7))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 64)
                                    .background(isSelected ? Color(red: 0.22, green: 0.74, blue: 0.97).opacity(0.2) : Color.white.opacity(0.05))
                                    .cornerRadius(14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(isSelected ? Color(red: 0.22, green: 0.74, blue: 0.97) : Color.white.opacity(0.15), lineWidth: isSelected ? 2 : 1)
                                    )
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(16)
            }

            VStack {
                Button(action: { viewModel.goToReview() }) {
                    Text("Next: Review Alarm")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color(red: 0.22, green: 0.74, blue: 0.97))
                        .cornerRadius(16)
                }
            }
            .padding(16)
            .background(Color(red: 0.06, green: 0.09, blue: 0.16))
        }
    }
}

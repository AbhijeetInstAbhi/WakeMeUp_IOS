import SwiftUI

public struct CreateAlarmView: View {
    @StateObject private var viewModel = CreateAlarmViewModel()

    public var onDone: () -> Void
    public var onCancel: () -> Void

    public var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.09, blue: 0.16).ignoresSafeArea()

            if viewModel.saved {
                AlarmSetSuccessView(placeName: viewModel.selected?.name ?? "", radiusMeters: viewModel.radiusMeters, onDone: onDone)
            } else {
                VStack(spacing: 0) {
                    // Header Bar
                    HStack {
                        Button(action: {
                            if viewModel.step == .search { onCancel() } else { viewModel.back() }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }

                        Spacer()

                        Text(headerTitle)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)

                        Spacer()
                    }
                    .padding(16)
                    .background(Color(red: 0.06, green: 0.09, blue: 0.16))

                    switch viewModel.step {
                    case .search: SearchStepView(viewModel: viewModel)
                    case .map: MapStepView(viewModel: viewModel)
                    case .radius: RadiusStepView(viewModel: viewModel)
                    case .review: ReviewStepView(viewModel: viewModel)
                    }
                }
            }
        }
    }

    private var headerTitle: String {
        switch viewModel.step {
        case .search: return "Search Location"
        case .map: return "Confirm on Map"
        case .radius: return "Radius & Transport Mode"
        case .review: return "Review & Confirm"
        }
    }
}

struct AlarmSetSuccessView: View {
    let placeName: String
    let radiusMeters: Int
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.06, green: 0.73, blue: 0.51).opacity(0.2))
                    .frame(width: 96, height: 96)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundColor(Color(red: 0.06, green: 0.73, blue: 0.51))
            }

            Text("Alarm Set!")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)

            Text("We'll wake you up when you're within \(radiusMeters / 1000) km of \(placeName).")
                .font(.system(size: 15))
                .foregroundColor(Color.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Button(action: onDone) {
                Text("Start Active Trip")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color(red: 0.22, green: 0.74, blue: 0.97))
                    .cornerRadius(16)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
    }
}

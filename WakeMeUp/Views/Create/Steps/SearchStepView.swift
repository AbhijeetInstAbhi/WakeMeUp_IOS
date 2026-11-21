import SwiftUI

public struct SearchStepView: View {
    @ObservedObject var viewModel: CreateAlarmViewModel

    public var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))
                TextField("Search location, petrol pump, restaurant...", text: Binding(
                    get: { viewModel.query },
                    set: { viewModel.onQueryChange($0) }
                ))
                .foregroundColor(.white)

                if viewModel.searching {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 0.22, green: 0.74, blue: 0.97)))
                }
            }
            .padding(14)
            .background(Color.white.opacity(0.08))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(red: 0.22, green: 0.74, blue: 0.97).opacity(0.5), lineWidth: 1)
            )

            if !viewModel.results.isEmpty {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(viewModel.results) { place in
                            Button(action: { viewModel.selectPlace(place) }) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.22, green: 0.74, blue: 0.97).opacity(0.2))
                                            .frame(width: 38, height: 38)
                                        Image(systemName: "location.fill")
                                            .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))
                                    }

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(place.name)
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                        Text(place.address)
                                            .font(.system(size: 12))
                                            .foregroundColor(Color.white.opacity(0.6))
                                            .lineLimit(1)
                                    }

                                    Spacer()
                                }
                                .padding(14)
                                .background(Color.white.opacity(0.07))
                                .cornerRadius(16)
                            }
                        }
                    }
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if !viewModel.searchHistory.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("RECENT SEARCHES")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(Color.white.opacity(0.5))
                                        .tracking(1)

                                    Spacer()

                                    Button("Clear All") {
                                        viewModel.clearSearchHistory()
                                    }
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))
                                }

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(viewModel.searchHistory, id: \.self) { hist in
                                            Button(action: { viewModel.runQuery(hist) }) {
                                                HStack(spacing: 6) {
                                                    Image(systemName: "clock.arrow.circlepath")
                                                        .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))
                                                    Text(hist)
                                                        .font(.system(size: 13))
                                                        .foregroundColor(.white)
                                                }
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(Color.white.opacity(0.08))
                                                .cornerRadius(12)
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Text("NEARBY CATEGORIES")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color.white.opacity(0.5))
                            .tracking(1)

                        let categories = [
                            ("Petrol Pump", "fuelpump.fill"),
                            ("Restaurants", "fork.knife"),
                            ("Train Station", "tram.fill"),
                            ("Bus Terminal", "bus.fill"),
                            ("Hospitals", "cross.case.fill"),
                            ("ATMs & Banks", "banknote.fill")
                        ]

                        ForEach(categories, id: \.0) { cat, icon in
                            Button(action: { viewModel.runQuery(cat) }) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.22, green: 0.74, blue: 0.97).opacity(0.15))
                                            .frame(width: 36, height: 36)
                                        Image(systemName: icon)
                                            .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97))
                                    }

                                    Text(cat)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.white)

                                    Spacer()

                                    Text("Find Nearby")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Color(red: 0.22, green: 0.74, blue: 0.97).opacity(0.7))
                                }
                                .padding(14)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(14)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
    }
}

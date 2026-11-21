import SwiftUI

public struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()

    public var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.09, blue: 0.16).ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Text("Trip History")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 8)

                if viewModel.historyAlarms.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()

                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 56))
                            .foregroundColor(Color.white.opacity(0.4))

                        Text("No past trips yet")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)

                        Text("Completed alarms will appear here")
                            .font(.system(size: 13))
                            .foregroundColor(Color.white.opacity(0.6))

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    List {
                        ForEach(viewModel.historyAlarms) { alarm in
                            HistoryRowView(
                                alarm: alarm,
                                onToggle: { enabled in viewModel.toggle(alarm, enabled: enabled) },
                                onDelete: { viewModel.delete(alarm) }
                            )
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
    }
}

struct HistoryRowView: View {
    let alarm: TravelAlarm
    let onToggle: (Bool) -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.06, green: 0.73, blue: 0.51).opacity(0.15))
                    .frame(width: 42, height: 42)
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(red: 0.06, green: 0.73, blue: 0.51))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(alarm.placeName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text("Completed · \(GeoUtils.formatRadius(alarm.radiusMeters)) radius")
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.6))

                Text(formatDate(alarm.createdAt))
                    .font(.system(size: 11))
                    .foregroundColor(Color.white.opacity(0.4))
            }

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(Color.white.opacity(0.5))
            }
            .buttonStyle(BorderedButtonStyle())

            Toggle("", isOn: Binding(
                get: { false },
                set: { onToggle($0) }
            ))
            .labelsHidden()
            .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.22, green: 0.74, blue: 0.97)))
        }
        .padding(14)
        .background(Color.white.opacity(0.07))
        .cornerRadius(16)
    }

    private func formatDate(_ millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(millis) / 1000.0)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}

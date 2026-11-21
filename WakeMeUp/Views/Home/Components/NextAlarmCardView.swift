import SwiftUI

public struct NextAlarmCardView: View {
    public var alarm: TravelAlarm
    public var settings: AppSettings
    public var onClick: () -> Void

    public var body: some View {
        Button(action: onClick) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("ACTIVE TRIP")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color.white.opacity(0.8))
                        .tracking(1)

                    Spacer()

                    Text("LIVE GPS · TAP TO VIEW")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.25))
                        .cornerRadius(50)
                }

                Text(alarm.placeName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)

                Text("Alerts within \(GeoUtils.formatRadius(alarm.radiusMeters, unit: settings.unit)) · \(alarm.transportMode.label)")
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.85))

                if let time = alarm.alarmTimeMillis {
                    Text(formatTime(time))
                        .font(.system(size: 13))
                        .foregroundColor(Color.white.opacity(0.75))
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.39, green: 0.40, blue: 0.95), Color(red: 0.31, green: 0.27, blue: 0.90)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(22)
        }
    }

    private func formatTime(_ millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(millis) / 1000.0)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, h:mm a"
        return formatter.string(from: date)
    }
}

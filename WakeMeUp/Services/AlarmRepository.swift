import Foundation
import Combine

public class AlarmRepository: ObservableObject {
    public static let shared = AlarmRepository()

    private let userDefaultsKey = "wakemeup_travel_alarms"

    @Published public var alarms: [TravelAlarm] = [] {
        didSet {
            save()
        }
    }

    private init() {
        load()
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([TravelAlarm].self, from: data) {
            self.alarms = decoded.sorted(by: { $0.createdAt > $1.createdAt })
        } else {
            self.alarms = []
        }
    }

    public func save() {
        if let encoded = try? JSONEncoder().encode(alarms) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    public func getArmedAlarms() -> [TravelAlarm] {
        return alarms.filter { $0.isArmed && $0.enabled && !$0.isReached }
    }

    public func getById(_ id: Int64) -> TravelAlarm? {
        return alarms.first(where: { $0.id == id })
    }

    public func upsert(_ alarm: TravelAlarm) {
        if let idx = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[idx] = alarm
        } else {
            alarms.insert(alarm, at: 0)
        }
    }

    public func toggleEnabled(_ alarm: TravelAlarm, enabled: Bool) {
        if enabled && alarm.isReached {
            rearmAsNewAlarm(alarm)
        } else if let idx = alarms.firstIndex(where: { $0.id == alarm.id }) {
            var updated = alarms[idx]
            updated.enabled = enabled
            updated.isArmed = enabled && !updated.isReached
            alarms[idx] = updated
        }
    }

    public func rearmAsNewAlarm(_ alarm: TravelAlarm) {
        if let idx = alarms.firstIndex(where: { $0.id == alarm.id }) {
            var updated = alarms[idx]
            updated.isReached = false
            updated.isArmed = true
            updated.enabled = true
            updated.createdAt = Int64(Date().timeIntervalSince1970 * 1000)
            alarms[idx] = updated
        }
    }

    public func disableAllArmedAlarms() {
        for i in 0..<alarms.count {
            if alarms[i].isArmed || alarms[i].enabled {
                alarms[i].isArmed = false
                alarms[i].enabled = false
            }
        }
    }

    public func markReached(id: Int64) {
        if let idx = alarms.firstIndex(where: { $0.id == id }) {
            var updated = alarms[idx]
            updated.isReached = true
            updated.isArmed = false
            updated.enabled = false
            alarms[idx] = updated
        }
    }

    public func delete(_ alarm: TravelAlarm) {
        alarms.removeAll(where: { $0.id == alarm.id })
    }
}

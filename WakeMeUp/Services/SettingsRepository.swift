import Foundation
import Combine

public class SettingsRepository: ObservableObject {
    public static let shared = SettingsRepository()

    private let userDefaultsKey = "wakemeup_app_settings"

    @Published public var settings: AppSettings {
        didSet {
            save()
        }
    }

    private init() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) {
            self.settings = decoded
        } else {
            self.settings = AppSettings()
        }
    }

    public func save() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    public func setVibrate(_ enabled: Bool) {
        settings.vibrate = enabled
    }

    public func setLoud(_ enabled: Bool) {
        settings.loudAlarm = enabled
    }

    public func setDefaultRadius(_ meters: Int) {
        settings.defaultRadiusMeters = meters
    }

    public func setUnit(_ unit: DistanceUnit) {
        settings.unit = unit
    }

    public func setOnboardingDone(_ done: Bool) {
        settings.onboardingDone = done
    }

    public func setSnoozeMinutes(_ minutes: Int) {
        settings.defaultSnoozeMinutes = minutes
    }

    public func setAutoSilenceMinutes(_ minutes: Int) {
        settings.autoSilenceMinutes = minutes
    }

    public func setSosContact(name: String, phone: String) {
        settings.sosContactName = name
        settings.sosContactPhone = phone
    }

    public func addSearchHistory(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed.count >= 2 else { return }

        var list = settings.searchHistory.filter { $0.caseInsensitiveCompare(trimmed) != .orderedSame }
        list.insert(trimmed, at: 0)
        settings.searchHistory = Array(list.prefix(10))
    }

    public func clearSearchHistory() {
        settings.searchHistory.removeAll()
    }
}

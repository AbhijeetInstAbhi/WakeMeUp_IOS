import Foundation

public enum DistanceUnit: String, Codable {
    case kilometers = "KILOMETERS"
    case miles = "MILES"
}

public struct AppSettings: Codable, Equatable {
    public var vibrate: Bool
    public var loudAlarm: Bool
    public var defaultRadiusMeters: Int
    public var unit: DistanceUnit
    public var onboardingDone: Bool
    public var searchHistory: [String]
    public var defaultSnoozeMinutes: Int
    public var autoSilenceMinutes: Int
    public var sosContactName: String
    public var sosContactPhone: String

    public init(
        vibrate: Bool = true,
        loudAlarm: Bool = true,
        defaultRadiusMeters: Int = 10000,
        unit: DistanceUnit = .kilometers,
        onboardingDone: Bool = false,
        searchHistory: [String] = [],
        defaultSnoozeMinutes: Int = 10,
        autoSilenceMinutes: Int = 5,
        sosContactName: String = "",
        sosContactPhone: String = ""
    ) {
        self.vibrate = vibrate
        self.loudAlarm = loudAlarm
        self.defaultRadiusMeters = defaultRadiusMeters
        self.unit = unit
        self.onboardingDone = onboardingDone
        self.searchHistory = searchHistory
        self.defaultSnoozeMinutes = defaultSnoozeMinutes
        self.autoSilenceMinutes = autoSilenceMinutes
        self.sosContactName = sosContactName
        self.sosContactPhone = sosContactPhone
    }
}

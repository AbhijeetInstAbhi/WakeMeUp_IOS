import Foundation
import CoreLocation

public struct TravelAlarm: Identifiable, Codable, Equatable {
    public var id: Int64
    public var placeName: String
    public var address: String
    public var latitude: Double
    public var longitude: Double
    public var radiusMeters: Int
    public var transportMode: TransportMode
    public var alarmTimeMillis: Int64?
    public var snoozeMinutes: Int
    public var enabled: Bool
    public var isArmed: Bool
    public var isReached: Bool
    public var createdAt: Int64

    public init(
        id: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        placeName: String,
        address: String,
        latitude: Double,
        longitude: Double,
        radiusMeters: Int,
        transportMode: TransportMode = .other,
        alarmTimeMillis: Int64? = nil,
        snoozeMinutes: Int = 10,
        enabled: Bool = true,
        isArmed: Bool = true,
        isReached: Bool = false,
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) {
        self.id = id
        self.placeName = placeName
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.radiusMeters = radiusMeters
        self.transportMode = transportMode
        self.alarmTimeMillis = alarmTimeMillis
        self.snoozeMinutes = snoozeMinutes
        self.enabled = enabled
        self.isArmed = isArmed
        self.isReached = isReached
        self.createdAt = createdAt
    }

    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

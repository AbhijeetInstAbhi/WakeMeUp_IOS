import Foundation
import CoreLocation

public struct PlaceSuggestion: Identifiable, Codable, Equatable, Hashable {
    public var id: String { "\(name)_\(latitude)_\(longitude)" }
    public var name: String
    public var address: String
    public var latitude: Double
    public var longitude: Double

    public init(name: String, address: String, latitude: Double, longitude: Double) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }

    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

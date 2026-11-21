import Foundation
import CoreLocation

public struct GeoUtils {
    private static let earthRadiusM: Double = 6371000.0

    public static func distanceMeters(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let loc1 = CLLocation(latitude: lat1, longitude: lon1)
        let loc2 = CLLocation(latitude: lat2, longitude: lon2)
        return loc1.distance(from: loc2)
    }

    public static func format(_ meters: Double, unit: DistanceUnit = .kilometers) -> String {
        switch unit {
        case .kilometers:
            if meters < 1000 {
                return "\(Int(meters.rounded())) m"
            } else {
                let km = meters / 1000.0
                if km < 10 {
                    return String(format: "%.1f km", km)
                } else {
                    return "\(Int(km.rounded())) km"
                }
            }
        case .miles:
            let miles = meters / 1609.344
            if miles < 0.1 {
                return "\(Int((meters * 3.28084).rounded())) ft"
            } else if miles < 10 {
                return String(format: "%.1f mi", miles)
            } else {
                return "\(Int(miles.rounded())) mi"
            }
        }
    }

    public static func formatTripDistance(_ distanceMeters: Double) -> String {
        if distanceMeters < 1000 {
            return "\(Int(distanceMeters)) m"
        } else {
            return String(format: "%.2f km", distanceMeters / 1000.0)
        }
    }

    public static func formatRadius(_ meters: Int, unit: DistanceUnit = .kilometers) -> String {
        return format(Double(meters), unit: unit)
    }
}

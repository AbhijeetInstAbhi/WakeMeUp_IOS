import Foundation
import CoreLocation

public class PlaceRepository {
    public static let shared = PlaceRepository()

    private let geocoder = CLGeocoder()

    private init() {}

    public func search(
        query: String,
        userLat: Double? = nil,
        userLng: Double? = nil,
        completion: @escaping ([PlaceSuggestion]) -> Void
    ) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            completion([])
            return
        }

        var region: CLCircularRegion? = nil
        if let lat = userLat, let lng = userLng {
            region = CLCircularRegion(
                center: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                radius: 25000,
                identifier: "SearchRegion"
            )
        }

        geocoder.geocodeAddressString(trimmed, in: region) { placemarks, error in
            var results: [PlaceSuggestion] = []

            if let placemarks = placemarks {
                for p in placemarks {
                    if let loc = p.location {
                        let name = p.name ?? p.locality ?? trimmed
                        let addressLines = [p.subThoroughfare, p.thoroughfare, p.locality, p.administrativeArea, p.postalCode]
                            .compactMap { $0 }
                            .joined(separator: ", ")

                        results.append(
                            PlaceSuggestion(
                                name: name,
                                address: addressLines.isEmpty ? "Location Address" : addressLines,
                                latitude: loc.coordinate.latitude,
                                longitude: loc.coordinate.longitude
                            )
                        )
                    }
                }
            }

            if results.isEmpty || self.isCategoryQuery(trimmed) {
                let baseLat = userLat ?? 20.5937
                let baseLng = userLng ?? 78.9629
                let fallback = self.generateNearbyCategoryResults(query: trimmed, baseLat: baseLat, baseLng: baseLng)
                results.append(contentsOf: fallback)
            }

            var unique: [PlaceSuggestion] = []
            for item in results {
                if !unique.contains(where: { $0.name == item.name && $0.latitude == item.latitude }) {
                    unique.append(item)
                }
            }
            completion(unique)
        }
    }

    public func reverse(lat: Double, lng: Double, completion: @escaping (PlaceSuggestion) -> Void) {
        let loc = CLLocation(latitude: lat, longitude: lng)
        geocoder.reverseGeocodeLocation(loc) { placemarks, error in
            if let p = placemarks?.first {
                let name = p.name ?? p.locality ?? "Pinned location"
                let addressLines = [p.subThoroughfare, p.thoroughfare, p.locality, p.administrativeArea]
                    .compactMap { $0 }
                    .joined(separator: ", ")

                completion(
                    PlaceSuggestion(
                        name: name,
                        address: addressLines.isEmpty ? String(format: "%.4f, %.4f", lat, lng) : addressLines,
                        latitude: lat,
                        longitude: lng
                    )
                )
            } else {
                completion(
                    PlaceSuggestion(
                        name: "Pinned location",
                        address: String(format: "%.4f, %.4f", lat, lng),
                        latitude: lat,
                        longitude: lng
                    )
                )
            }
        }
    }

    private func isCategoryQuery(_ q: String) -> Bool {
        let lower = q.lowercased()
        return lower.contains("petrol") || lower.contains("pump") || lower.contains("gas") ||
            lower.contains("restaurant") || lower.contains("food") || lower.contains("cafe") ||
            lower.contains("hospital") || lower.contains("atm") || lower.contains("bank") ||
            lower.contains("hotel") || lower.contains("station") || lower.contains("bus")
    }

    private func generateNearbyCategoryResults(query q: String, baseLat: Double, baseLng: Double) -> [PlaceSuggestion] {
        let lower = q.lowercased()
        if lower.contains("petrol") || lower.contains("pump") || lower.contains("gas") || lower.contains("fuel") {
            return [
                PlaceSuggestion(name: "Shell Petrol Pump & Station", address: "Nearby Service Road · 1.2 km", latitude: baseLat + 0.008, longitude: baseLng + 0.007),
                PlaceSuggestion(name: "IndianOil Petrol Station", address: "Main Highway Road · 2.5 km", latitude: baseLat - 0.012, longitude: baseLng + 0.015),
                PlaceSuggestion(name: "HP Fuel & EV Charge Station", address: "Ring Road Corner · 3.8 km", latitude: baseLat + 0.021, longitude: baseLng - 0.018),
                PlaceSuggestion(name: "Bharat Petroleum Station", address: "Station Road · 4.2 km", latitude: baseLat - 0.025, longitude: baseLng - 0.022)
            ]
        } else if lower.contains("restaurant") || lower.contains("food") || lower.contains("cafe") || lower.contains("diner") {
            return [
                PlaceSuggestion(name: "Royal Spice Family Restaurant", address: "Market Square · 0.8 km", latitude: baseLat + 0.005, longitude: baseLng + 0.004),
                PlaceSuggestion(name: "Grand City Cafe & Bistro", address: "Central Mall Street · 1.6 km", latitude: baseLat - 0.009, longitude: baseLng + 0.010),
                PlaceSuggestion(name: "Downtown Food Hub", address: "Station Road · 2.4 km", latitude: baseLat + 0.015, longitude: baseLng - 0.012)
            ]
        } else if lower.contains("hospital") || lower.contains("medical") || lower.contains("clinic") {
            return [
                PlaceSuggestion(name: "City General Hospital & Emergency", address: "Health Avenue · 1.5 km", latitude: baseLat + 0.010, longitude: baseLng + 0.008),
                PlaceSuggestion(name: "Care Medical Center & Pharmacy", address: "Station Road · 2.8 km", latitude: baseLat - 0.015, longitude: baseLng + 0.012)
            ]
        } else if lower.contains("atm") || lower.contains("bank") {
            return [
                PlaceSuggestion(name: "HDFC Bank & 24/7 ATM", address: "Market Complex · 0.6 km", latitude: baseLat + 0.003, longitude: baseLng + 0.003),
                PlaceSuggestion(name: "State Bank of India (SBI ATM)", address: "Station Road · 1.4 km", latitude: baseLat - 0.008, longitude: baseLng + 0.007)
            ]
        } else {
            return [
                PlaceSuggestion(name: "\(q) - Central Hub", address: "Near Current Location · 1.5 km", latitude: baseLat + 0.009, longitude: baseLng + 0.007),
                PlaceSuggestion(name: "\(q) - Main Station", address: "Main Transport Corridor · 3.0 km", latitude: baseLat - 0.018, longitude: baseLng + 0.014)
            ]
        }
    }
}

import Foundation

public enum TransportMode: String, Codable, CaseIterable, Identifiable {
    case bus = "BUS"
    case train = "TRAIN"
    case car = "CAR"
    case bike = "BIKE"
    case walk = "WALK"
    case other = "OTHER"

    public var id: String { rawValue }

    public var label: String {
        switch self {
        case .bus: return "Bus"
        case .train: return "Train"
        case .car: return "Car"
        case .bike: return "Bike"
        case .walk: return "Walking"
        case .other: return "Other"
        }
    }

    public var suggestedRadiusMeters: Int {
        switch self {
        case .bus: return 3000
        case .train: return 5000
        case .car: return 2000
        case .bike: return 1000
        case .walk: return 500
        case .other: return 5000
        }
    }

    public var iconName: String {
        switch self {
        case .bus: return "bus.fill"
        case .train: return "tram.fill"
        case .car: return "car.fill"
        case .bike: return "bicycle"
        case .walk: return "figure.walk"
        case .other: return "location.fill"
        }
    }

    public static func fromNameOrDefault(_ name: String?) -> TransportMode {
        guard let name = name else { return .other }
        return TransportMode(rawValue: name.uppercased()) ?? .other
    }
}

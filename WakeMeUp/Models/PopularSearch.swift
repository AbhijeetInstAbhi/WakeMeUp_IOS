import Foundation

public enum PopularSearch: String, CaseIterable, Identifiable {
    case airport = "Airport"
    case trainStation = "Central Station"
    case busTerminal = "Bus Terminal"
    case downtown = "City Center"
    case university = "University"

    public var id: String { rawValue }

    public var label: String { rawValue }

    public var query: String {
        switch self {
        case .airport: return "Airport"
        case .trainStation: return "Central Train Station"
        case .busTerminal: return "Main Bus Stand"
        case .downtown: return "City Center"
        case .university: return "University"
        }
    }
}

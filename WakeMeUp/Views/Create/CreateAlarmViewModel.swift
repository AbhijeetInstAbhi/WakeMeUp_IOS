import Foundation
import Combine
import CoreLocation

public enum CreateStep {
    case search
    case map
    case radius
    case review
}

public class CreateAlarmViewModel: ObservableObject {
    @Published public var step: CreateStep = .search
    @Published public var query: String = ""
    @Published public var searching: Bool = false
    @Published public var results: [PlaceSuggestion] = []
    @Published public var selected: PlaceSuggestion? = nil
    @Published public var userLocation: CLLocationCoordinate2D? = nil
    @Published public var radiusMeters: Int = 10000
    @Published public var transportMode: TransportMode = .other
    @Published public var alarmTimeMillis: Int64? = nil
    @Published public var snoozeMinutes: Int = 10
    @Published public var saved: Bool = false
    @Published public var searchHistory: [String] = []

    private var cancellables = Set<AnyCancellable>()

    public init() {
        self.radiusMeters = SettingsRepository.shared.settings.defaultRadiusMeters
        self.searchHistory = SettingsRepository.shared.settings.searchHistory

        SettingsRepository.shared.$settings
            .sink { [weak self] s in
                self?.searchHistory = s.searchHistory
            }
            .store(in: &cancellables)

        LocationManager.shared.$userLocation
            .sink { [weak self] loc in
                if let loc = loc {
                    self?.userLocation = loc
                }
            }
            .store(in: &cancellables)
    }

    public func onQueryChange(_ q: String) {
        self.query = q
        guard q.count >= 2 else {
            self.results = []
            self.searching = false
            return
        }

        self.searching = true
        PlaceRepository.shared.search(query: q, userLat: userLocation?.latitude, userLng: userLocation?.longitude) { [weak self] res in
            DispatchQueue.main.async {
                self?.results = res
                self?.searching = false
            }
        }
    }

    public func runQuery(_ q: String) {
        self.query = q
        self.searching = true
        PlaceRepository.shared.search(query: q, userLat: userLocation?.latitude, userLng: userLocation?.longitude) { [weak self] res in
            DispatchQueue.main.async {
                self?.results = res
                self?.searching = false
                SettingsRepository.shared.addSearchHistory(q)
            }
        }
    }

    public func selectPlace(_ place: PlaceSuggestion) {
        SettingsRepository.shared.addSearchHistory(place.name)
        self.selected = place
        self.step = .map
    }

    public func clearSearchHistory() {
        SettingsRepository.shared.clearSearchHistory()
    }

    public func onMapPointPicked(lat: Double, lng: Double) {
        PlaceRepository.shared.reverse(lat: lat, lng: lng) { [weak self] place in
            DispatchQueue.main.async {
                self?.selected = place
            }
        }
    }

    public func confirmLocation() {
        self.step = .radius
    }

    public func setRadius(_ meters: Int) {
        self.radiusMeters = meters
    }

    public func setTransportMode(_ mode: TransportMode) {
        self.transportMode = mode
        self.radiusMeters = mode.suggestedRadiusMeters
    }

    public func goToReview() {
        self.step = .review
    }

    public func back() {
        switch step {
        case .review: step = .radius
        case .radius: step = .map
        case .map: step = .search
        case .search: step = .search
        }
    }

    public func save() {
        guard let place = selected else { return }
        let newAlarm = TravelAlarm(
            placeName: place.name,
            address: place.address,
            latitude: place.latitude,
            longitude: place.longitude,
            radiusMeters: radiusMeters,
            transportMode: transportMode,
            alarmTimeMillis: alarmTimeMillis,
            snoozeMinutes: snoozeMinutes,
            enabled: true,
            isArmed: true,
            createdAt: Int64(Date().timeIntervalSince1970 * 1000)
        )

        AlarmRepository.shared.upsert(newAlarm)
        LocationManager.shared.startTracking(alarm: newAlarm)
        self.saved = true
    }
}

import Foundation
import Combine

public class HomeViewModel: ObservableObject {
    @Published public var activeAlarm: TravelAlarm?
    private var cancellables = Set<AnyCancellable>()

    public init() {
        AlarmRepository.shared.$alarms
            .sink { [weak self] alarms in
                self?.activeAlarm = alarms.first(where: { $0.isArmed && $0.enabled && !$0.isReached })
            }
            .store(in: &cancellables)
    }

    public func stopActiveTrip() {
        AlarmRepository.shared.disableAllArmedAlarms()
        LocationManager.shared.stopTracking()
    }
}

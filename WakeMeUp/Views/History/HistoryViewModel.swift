import Foundation
import Combine

public class HistoryViewModel: ObservableObject {
    @Published public var historyAlarms: [TravelAlarm] = []
    private var cancellables = Set<AnyCancellable>()

    public init() {
        AlarmRepository.shared.$alarms
            .sink { [weak self] list in
                self?.historyAlarms = list.filter { $0.isReached }
            }
            .store(in: &cancellables)
    }

    public func toggle(_ alarm: TravelAlarm, enabled: Bool) {
        if enabled {
            AlarmRepository.shared.rearmAsNewAlarm(alarm)
            if let updated = AlarmRepository.shared.getById(alarm.id) {
                LocationManager.shared.startTracking(alarm: updated)
            }
        } else {
            AlarmRepository.shared.toggleEnabled(alarm, enabled: false)
        }
    }

    public func delete(_ alarm: TravelAlarm) {
        AlarmRepository.shared.delete(alarm)
    }
}

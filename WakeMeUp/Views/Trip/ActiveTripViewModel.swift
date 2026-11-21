import Foundation
import Combine

public class ActiveTripViewModel: ObservableObject {
    @Published var locationManager = LocationManager.shared

    public func stopTrip() {
        AlarmRepository.shared.disableAllArmedAlarms()
        LocationManager.shared.stopTracking()
    }
}

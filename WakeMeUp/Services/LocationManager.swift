import Foundation
import CoreLocation
import Combine
import UserNotifications

public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    public static let shared = LocationManager()

    private let locationManager = CLLocationManager()

    @Published public var userLocation: CLLocationCoordinate2D?
    @Published public var authorizationStatus: CLAuthorizationStatus = .notDetermined

    // Trip Tracking State
    @Published public var isTracking: Bool = false
    @Published public var destinationName: String = ""
    @Published public var destinationAddress: String = ""
    @Published public var remainingDistance: Double = 0.0
    @Published public var initialDistance: Double = 0.0
    @Published public var radiusMeters: Int = 0
    @Published public var currentLat: Double = 0.0
    @Published public var currentLng: Double = 0.0
    @Published public var destinationLat: Double = 0.0
    @Published public var destinationLng: Double = 0.0
    @Published public var transportMode: TransportMode = .other
    @Published public var isCompleted: Bool = false
    @Published public var completedTimeMillis: Int64 = 0

    @Published public var shouldRingAlarm: Bool = false
    @Published public var ringingAlarm: TravelAlarm?

    private var autoSilenceTimer: Timer?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 2.0
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false

        UNUserNotificationCenter.current().delegate = self
        requestPermissions()
    }

    public func requestPermissions() {
        locationManager.requestAlwaysAuthorization()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    public func startTracking(alarm: TravelAlarm) {
        self.isTracking = true
        self.destinationName = alarm.placeName
        self.destinationAddress = alarm.address
        self.radiusMeters = alarm.radiusMeters
        self.destinationLat = alarm.latitude
        self.destinationLng = alarm.longitude
        self.transportMode = alarm.transportMode
        self.isCompleted = false
        self.shouldRingAlarm = false

        if let current = userLocation {
            let dist = GeoUtils.distanceMeters(lat1: current.latitude, lon1: current.longitude, lat2: alarm.latitude, lon2: alarm.longitude)
            self.remainingDistance = dist
            self.initialDistance = dist
        } else {
            self.remainingDistance = 15000.0
            self.initialDistance = 15000.0
        }

        locationManager.startUpdatingLocation()

        let region = CLCircularRegion(
            center: alarm.coordinate,
            radius: CLLocationDistance(alarm.radiusMeters),
            identifier: "\(alarm.id)"
        )
        region.notifyOnEntry = true
        region.notifyOnExit = false
        locationManager.startMonitoring(for: region)
    }

    public func stopTracking() {
        self.isTracking = false
        self.remainingDistance = 0.0
        self.initialDistance = 0.0
        self.radiusMeters = 0
        self.isCompleted = false
        self.autoSilenceTimer?.invalidate()
        self.autoSilenceTimer = nil

        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
        locationManager.stopUpdatingLocation()
    }

    public func triggerAlarmCompletion(alarmId: Int64? = nil) {
        self.isTracking = false
        self.isCompleted = true
        self.completedTimeMillis = Int64(Date().timeIntervalSince1970 * 1000)

        if let alarmId = alarmId {
            AlarmRepository.shared.markReached(id: alarmId)
            self.ringingAlarm = AlarmRepository.shared.getById(alarmId)
        } else if let active = AlarmRepository.shared.getArmedAlarms().first {
            AlarmRepository.shared.markReached(id: active.id)
            self.ringingAlarm = active
        } else {
            AlarmRepository.shared.disableAllArmedAlarms()
        }

        self.shouldRingAlarm = true
        sendLocalNotification()
        AlarmSoundPlayer.shared.start(
            vibrate: SettingsRepository.shared.settings.vibrate,
            loud: SettingsRepository.shared.settings.loudAlarm
        )

        let autoSilenceMins = SettingsRepository.shared.settings.autoSilenceMinutes
        if autoSilenceMins > 0 {
            autoSilenceTimer?.invalidate()
            autoSilenceTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(autoSilenceMins * 60), repeats: false) { [weak self] _ in
                DispatchQueue.main.async {
                    if self?.shouldRingAlarm == true {
                        AlarmSoundPlayer.shared.stop()
                        self?.shouldRingAlarm = false
                    }
                }
            }
        }
    }

    public func scheduleSnooze(minutes: Int) {
        AlarmSoundPlayer.shared.stop()
        self.shouldRingAlarm = false

        let content = UNMutableNotificationContent()
        content.title = "⏰ SNOOZE EXPIRED - WAKE UP!"
        content.body = "You are near \(destinationName.isEmpty ? "your destination" : destinationName). Tap to stop alarm."
        content.sound = UNNotificationSound.defaultCritical
        content.categoryIdentifier = "ALARM_CATEGORY"

        let delaySecs = TimeInterval(max(1, minutes * 60))
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delaySecs, repeats: false)
        let request = UNNotificationRequest(identifier: "WAKEMEUP_SNOOZE_\(Date().timeIntervalSince1970)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)

        Timer.scheduledTimer(withTimeInterval: delaySecs, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.shouldRingAlarm = true
                self?.sendLocalNotification()
                AlarmSoundPlayer.shared.start(
                    vibrate: SettingsRepository.shared.settings.vibrate,
                    loud: SettingsRepository.shared.settings.loudAlarm
                )
            }
        }
    }

    private func sendLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "⏰ WAKE UP!"
        content.body = "You are within radius of \(destinationName.isEmpty ? "your destination" : destinationName)! Tap to view alarm."
        content.sound = UNNotificationSound.defaultCritical
        content.categoryIdentifier = "ALARM_CATEGORY"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "WAKEMEUP_ALARM", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - UNUserNotificationCenterDelegate

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge, .list])
    }

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        DispatchQueue.main.async {
            self.shouldRingAlarm = true
            AlarmSoundPlayer.shared.start(
                vibrate: SettingsRepository.shared.settings.vibrate,
                loud: SettingsRepository.shared.settings.loudAlarm
            )
        }
        completionHandler()
    }

    // MARK: - CLLocationManagerDelegate

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                self.locationManager.startUpdatingLocation()
            }
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
            self.currentLat = location.coordinate.latitude
            self.currentLng = location.coordinate.longitude

            if self.isTracking && !self.isCompleted && self.destinationLat != 0.0 && self.destinationLng != 0.0 {
                let dist = location.distance(from: CLLocation(latitude: self.destinationLat, longitude: self.destinationLng))
                self.remainingDistance = dist

                if self.radiusMeters > 0 && dist <= Double(self.radiusMeters) {
                    self.triggerAlarmCompletion()
                }
            }
        }
    }

    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion, let alarmId = Int64(circularRegion.identifier) {
            DispatchQueue.main.async {
                self.triggerAlarmCompletion(alarmId: alarmId)
            }
        }
    }
}

import XCTest
@testable import WakeMeUp

final class WakeMeUpTests: XCTestCase {

    func testDistanceCalculation() {
        // Distance between NYC (40.7128, -74.0060) and LA (34.0522, -118.2437)
        let dist = GeoUtils.distanceMeters(lat1: 40.7128, lon1: -74.0060, lat2: 34.0522, lon2: -118.2437)
        XCTAssertGreaterThan(dist, 3_900_000) // ~3,935 km
    }

    func testFormatting() {
        let formattedM = GeoUtils.formatTripDistance(450)
        XCTAssertEqual(formattedM, "450 m")

        let formattedKm = GeoUtils.formatTripDistance(12400)
        XCTAssertEqual(formattedKm, "12.40 km")
    }

    func testTransportModeDefaults() {
        XCTAssertEqual(TransportMode.bus.suggestedRadiusMeters, 3000)
        XCTAssertEqual(TransportMode.train.suggestedRadiusMeters, 5000)
        XCTAssertEqual(TransportMode.car.suggestedRadiusMeters, 2000)
        XCTAssertEqual(TransportMode.walk.suggestedRadiusMeters, 500)
    }

    func testAlarmModelInitialization() {
        let alarm = TravelAlarm(
            placeName: "Central Station",
            address: "Main Street 100",
            latitude: 40.7128,
            longitude: -74.0060,
            radiusMeters: 2000,
            transportMode: .train
        )

        XCTAssertEqual(alarm.placeName, "Central Station")
        XCTAssertTrue(alarm.isArmed)
        XCTAssertFalse(alarm.isReached)
        XCTAssertEqual(alarm.radiusMeters, 2000)
    }
}

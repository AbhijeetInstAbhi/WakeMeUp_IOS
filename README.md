# 📍 WakeMeUp - Location-Based Commute Alarms (iOS)

**WakeMeUp** is a native **iOS (Swift & SwiftUI)** location-based alarm and real-time GPS travel tracking application designed for commuters, train & bus passengers, drivers, and daily travelers. Never oversleep or miss your stop again!

---

## ✨ Features

- 🚌 **Commute Mode Selection**: Custom transport modes (*Bus, Train/Metro, Car, Bike, Walking, Other*) with dynamic suggested alert radiuses.
- 🎯 **Smart Geofence Alarms**: Uses Apple `CoreLocation` & `CLCircularRegion` to trigger alarms precisely when entering your target radius.
- 🗺️ **Interactive Route Maps**: MapKit integration with polylines connecting your start location to the destination, custom Start & End markers, and adjustable radius overlays.
- ⏱️ **Live GPS Countdown**: Active Trip view showing remaining distance, ETA estimates, and animated radar visualizers.
- 🔔 **Lock Screen & Background Ringing**: Receives background location updates (`allowsBackgroundLocationUpdates`) and displays full-screen alert notifications when the screen is locked or the app is closed.
- 🚨 **Emergency SOS Protection**: Prefills emergency SMS with a live Google Maps location link (`https://maps.google.com/?q=lat,lng`) or calls your emergency contact with one tap.
- 📜 **Trip History & In-Place Re-Arming**: Re-enable completed trips directly without creating duplicate items.
- ⚙️ **Customizable Preferences**: Vibrate mode, loud volume boost, snooze duration selector (5m, 10m, 15m, 20m), auto-silence timer (3m, 5m, 10m, Never), and test ringtone playback.
- 🌙 **Dark Theme UI**: Electric Blue (`#38BDF8`) dark appearance.

---

## 🛠️ Tech Stack & Architecture

- **Language**: Swift 5
- **UI Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel with `ObservableObject` & `@Published`)
- **Location & Geofencing**: `CoreLocation`, `CLLocationManager`, `CLCircularRegion`
- **Mapping**: `MapKit` (`MKMapView`, `MKPolyline`, `MKCircle`)
- **Notifications**: `UserNotifications` (`UNUserNotificationCenter`)
- **Audio & Haptics**: `AVAudioPlayer`, `AVAudioSession`, `UIImpactFeedbackGenerator`
- **Persistence**: `UserDefaults` + JSON DataStore (`AlarmRepository`, `SettingsRepository`)
- **Testing**: `XCTest` unit test suite

---

## 📂 Project Structure

```
iOS/WakeMeUp/
├── WakeMeUp.xcodeproj/               # Xcode Project Configuration
├── WakeMeUp/
│   ├── Info.plist                     # Permissions & UIBackgroundModes
│   ├── WakeMeUpApp.swift              # Main SwiftUI App Entry Point
│   ├── Models/                        # TravelAlarm, TransportMode, AppSettings
│   ├── Services/                      # LocationManager, AlarmRepository, SettingsRepository, PlaceRepository, AlarmSoundPlayer
│   ├── Utilities/                     # GeoUtils (Haversine distance & formatting)
│   ├── Views/                         # MainTabView, SplashScreenView, OnboardingView, HomeView, CreateAlarmView, ActiveTripView, AlarmRingView, HistoryView, SettingsView, SosConfigView, FeedbackView
│   └── Resources/                     # Assets.xcassets (AppIcon)
└── WakeMeUpTests/                     # XCTest Unit Test Suite
```

---

## 🚀 Getting Started

### Requirements
- Mac running **macOS 13.0+**
- **Xcode 15.0** or later
- **iOS 15.0+** device or simulator

### Build & Run
1. Clone or download the repository:
   ```bash
   git clone https://github.com/AbhijeetInstAbhi/WakeMeUp_IOS.git
   cd WakeMeUp_IOS
   ```
2. Open `WakeMeUp.xcodeproj` in Xcode.
3. Select your target simulator (e.g. *iPhone 16 Pro*) or connected iPhone.
4. Press **`Cmd + R`** to build and run.

---

## 🧪 Unit Tests

Run the built-in unit tests in Xcode by pressing **`Cmd + U`**.
Tested modules:
- Haversine distance calculations
- Distance string formatting (`m`, `km`)
- Transport mode defaults and suggested radiuses
- Alarm model initialization and status toggling

---

## 📄 License & Author

Created for **WakeMeUp** - All Rights Reserved.
Feedback recipient email: `singhabhijeet105@gmail.com`

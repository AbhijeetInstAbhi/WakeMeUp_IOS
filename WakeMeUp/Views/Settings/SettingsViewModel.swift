import Foundation
import Combine

public class SettingsViewModel: ObservableObject {
    @Published public var settings: AppSettings = SettingsRepository.shared.settings
    private var cancellables = Set<AnyCancellable>()

    public init() {
        SettingsRepository.shared.$settings
            .sink { [weak self] s in
                self?.settings = s
            }
            .store(in: &cancellables)
    }

    public func setVibrate(_ enabled: Bool) {
        SettingsRepository.shared.setVibrate(enabled)
    }

    public func setLoud(_ enabled: Bool) {
        SettingsRepository.shared.setLoud(enabled)
    }

    public func setSnoozeMinutes(_ minutes: Int) {
        SettingsRepository.shared.setSnoozeMinutes(minutes)
    }

    public func setAutoSilenceMinutes(_ minutes: Int) {
        SettingsRepository.shared.setAutoSilenceMinutes(minutes)
    }

    public func setSosContact(name: String, phone: String) {
        SettingsRepository.shared.setSosContact(name: name, phone: phone)
    }
}

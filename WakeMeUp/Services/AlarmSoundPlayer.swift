import Foundation
import AVFoundation
import AudioToolbox
import UIKit

public class AlarmSoundPlayer {
    public static let shared = AlarmSoundPlayer()

    private var audioPlayer: AVAudioPlayer?
    private var vibrationTimer: Timer?

    private init() {}

    public func start(vibrate: Bool = true, loud: Bool = true) {
        stop()

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AVAudioSession error: \(error)")
        }

        if let soundURL = Bundle.main.url(forResource: "alarm", withExtension: "mp3") {
            audioPlayer = try? AVAudioPlayer(contentsOf: soundURL)
        } else {
            let defaultPath = "/System/Library/Audio/UISounds/alarm.caf"
            if let url = URL(string: defaultPath) {
                audioPlayer = try? AVAudioPlayer(contentsOf: url)
            }
        }

        audioPlayer?.numberOfLoops = -1
        if loud {
            audioPlayer?.volume = 1.0
        }
        audioPlayer?.play()

        if vibrate {
            vibrationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            }
        }
    }

    public func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        vibrationTimer?.invalidate()
        vibrationTimer = nil
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {}
    }
}

//
//  AlarmSoundPlayer.swift
//  SnapWake
//
//  Created by Claude on 20/03/2026.
//

import Foundation
import AVFoundation
import UIKit

/// Helper pour jouer les sons d'alarme dans l'app
class AlarmSoundPlayer {
    static let shared = AlarmSoundPlayer()

    private var audioPlayer: AVAudioPlayer?
    private var isAlarmPlaying = false

    private init() {
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            // Configure pour que le son joue même en mode silencieux
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.mixWithOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }

    /// Jouer le son d'alarme en boucle
    func playAlarm(soundName: String) {
        guard !isAlarmPlaying else {
            print("Alarm already playing")
            return
        }

        // Get the file name from SoundManager
        guard let fileName = SoundManager.shared.getFileName(for: soundName) else {
            print("Sound '\(soundName)' not found")
            playDefaultAlarm()
            return
        }

        // Try to find the sound file
        var soundURL: URL?

        if let url = Bundle.main.url(forResource: fileName, withExtension: "mp3", subdirectory: "Resources/Sounds") {
            soundURL = url
        } else if let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            soundURL = url
        }

        guard let url = soundURL else {
            print("Sound file not found: \(fileName).mp3")
            playDefaultAlarm()
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1  // Loop infinitely
            audioPlayer?.volume = 1.0
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isAlarmPlaying = true

            // Vibrate the phone
            vibratePhone()

            print("🔔 Alarm playing: \(soundName)")
        } catch {
            print("Failed to play alarm: \(error)")
            playDefaultAlarm()
        }
    }

    /// Arrêter l'alarme
    func stopAlarm() {
        audioPlayer?.stop()
        audioPlayer = nil
        isAlarmPlaying = false
        print("🔕 Alarm stopped")
    }

    /// Vérifier si l'alarme joue
    func isPlaying() -> Bool {
        return isAlarmPlaying
    }

    /// Jouer l'alarme par défaut du système
    private func playDefaultAlarm() {
        // Fallback to system sound
        let systemSoundID: SystemSoundID = 1005  // SMS received sound
        AudioServicesPlaySystemSound(systemSoundID)
        vibratePhone()
    }

    /// Faire vibrer le téléphone
    private func vibratePhone() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

        // Vibrate repeatedly while alarm is playing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self, self.isAlarmPlaying else { return }
            self.vibratePhone()
        }
    }

    /// Augmenter progressivement le volume (fade in)
    func fadeInVolume(duration: TimeInterval = 10.0) {
        guard let player = audioPlayer else { return }

        player.volume = 0.1
        player.setVolume(1.0, fadeDuration: duration)
    }
}

// MARK: - Extension pour UserDefaults (sauvegarder le son sélectionné)
extension UserDefaults {
    private static let selectedAlarmSoundKey = "selectedAlarmSound"

    var selectedAlarmSound: String {
        get {
            return string(forKey: UserDefaults.selectedAlarmSoundKey) ?? "Default"
        }
        set {
            set(newValue, forKey: UserDefaults.selectedAlarmSoundKey)
        }
    }
}

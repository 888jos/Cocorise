//
//  SoundManager.swift
//  SnapWake
//
//  Created by Claude on 20/03/2026.
//

import Foundation
import AVFoundation

class SoundManager: ObservableObject {
    static let shared = SoundManager()

    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false

    // Liste de tous les sons disponibles
    let availableSounds: [String: String] = [
        // CLASSIC
        "Default": "default",
        "Alarm Clock Bell": "alarm_clock_bell",
        "UK Tea Timer": "uk_tea_timer",

        // AGGRESSIVE
        "Air Raid Siren": "air_raid_siren",
        "Rooster Crowing": "rooster_crowing",

        // PEACEFUL
        "Morning Birds": "morning_birds",
        "Ocean Waves": "ocean_waves",
        "Zen Garden": "zen_garden"
    ]

    private init() {
        // Configure audio session for alarm sounds
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    /// Play a sound by display name
    func playSound(named displayName: String, loop: Bool = false) {
        guard let fileName = availableSounds[displayName] else {
            print("Sound '\(displayName)' not found in available sounds")
            return
        }

        playSoundFile(fileName, loop: loop)
    }

    /// Play a sound file directly
    func playSoundFile(_ fileName: String, loop: Bool = false) {
        // Try to find the sound in Resources/Sounds first
        var soundURL: URL?

        if let url = Bundle.main.url(forResource: fileName, withExtension: "mp3", subdirectory: "Resources/Sounds") {
            soundURL = url
        } else if let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            soundURL = url
        }

        guard let url = soundURL else {
            print("Sound file '\(fileName).mp3' not found in bundle")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = loop ? -1 : 0  // -1 = infinite loop
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true

            print("Playing sound: \(fileName)")
        } catch {
            print("Failed to play sound: \(error)")
        }
    }

    /// Stop the currently playing sound
    func stopSound() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
    }

    /// Pause the currently playing sound
    func pauseSound() {
        audioPlayer?.pause()
        isPlaying = false
    }

    /// Resume the paused sound
    func resumeSound() {
        audioPlayer?.play()
        isPlaying = true
    }

    /// Preview a sound (play for 3 seconds then stop)
    func previewSound(named displayName: String) {
        playSound(named: displayName, loop: false)

        // Auto-stop after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.stopSound()
        }
    }

    /// Get the file name for a display name
    func getFileName(for displayName: String) -> String? {
        return availableSounds[displayName]
    }

    /// Get the display name for a file name
    func getDisplayName(for fileName: String) -> String? {
        return availableSounds.first(where: { $0.value == fileName })?.key
    }

    /// Check if a sound exists
    func soundExists(named displayName: String) -> Bool {
        guard let fileName = availableSounds[displayName] else { return false }
        return Bundle.main.url(forResource: fileName, withExtension: "mp3", subdirectory: "Resources/Sounds") != nil ||
               Bundle.main.url(forResource: fileName, withExtension: "mp3") != nil
    }
}

// Extension pour faciliter l'utilisation dans SwiftUI
extension SoundManager {
    /// Get all sounds grouped by category
    func getSoundsByCategory() -> [(category: String, icon: String, sounds: [String], colors: [String])] {
        return [
            (
                category: "CLASSIC",
                icon: "",
                sounds: ["Default", "Alarm Clock Bell", "UK Tea Timer"],
                colors: ["8E8E93", "5E6C84", "6B8E23"]
            ),
            (
                category: "AGGRESSIVE",
                icon: "⚡",
                sounds: ["Air Raid Siren", "Rooster Crowing"],
                colors: ["DC143C", "8B4513"]
            ),
            (
                category: "PEACEFUL",
                icon: "🧘",
                sounds: ["Morning Birds", "Ocean Waves", "Zen Garden"],
                colors: ["87CEEB", "4682B4", "2E8B57"]
            )
        ]
    }
}

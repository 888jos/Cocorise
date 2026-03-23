//
//  AudioPlayerService.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import AVFoundation
import Foundation

class AudioPlayerService: ObservableObject {
    static let shared = AudioPlayerService()

    private var player: AVAudioPlayer?
    @Published var isPlaying = false

    init() {
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            // Configure audio session to play even in silent mode
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }

    func playSound(_ sound: AlarmSound) {
        stopSound()

        guard let url = Bundle.main.url(forResource: sound.fileName, withExtension: "mp3") else {
            print("Sound file not found: \(sound.fileName).mp3")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            isPlaying = true

            // Arrêter automatiquement après 10 secondes (preview)
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
                self?.stopSound()
            }
        } catch {
            print("Error playing sound: \(error)")
        }
    }

    func playSound(_ soundName: String) {
        // Find sound by name and play it
        if let sound = SoundsLibrary.shared.sound(named: soundName) {
            playSound(sound)
        }
    }

    func playAlarmSound(_ soundName: String, loop: Bool = true, volume: Float = 1.0) {
        stopSound()

        if let sound = SoundsLibrary.shared.sound(named: soundName),
           let url = Bundle.main.url(forResource: sound.fileName, withExtension: "mp3") {

            do {
                // Reconfigure audio session for alarm (critical)
                try AVAudioSession.sharedInstance().setCategory(.playback, options: [])
                try AVAudioSession.sharedInstance().setActive(true)

                player = try AVAudioPlayer(contentsOf: url)
                player?.numberOfLoops = loop ? -1 : 0 // -1 = infinite loop
                player?.volume = volume
                player?.prepareToPlay()
                player?.play()
                isPlaying = true
            } catch {
                print("Error playing alarm sound: \(error)")
            }
        }
    }

    func stopSound() {
        player?.stop()
        player = nil
        isPlaying = false
    }
}

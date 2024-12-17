//
//  ColorSoundPlayer.swift
//  SimonDice
//
//  Created by Marco Alonso Rodriguez on 16/12/24.
//

import Foundation
import AVFoundation

class ColorSoundPlayer {
    static let shared = ColorSoundPlayer()
    private var player: AVAudioPlayer?

    func playSound(for color: String) {
        guard let path = Bundle.main.path(forResource: color, ofType: "wav") else { return }
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Could not play sound: \(error.localizedDescription)")
        }
    }
}

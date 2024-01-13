//
//  AudioPlayer.swift
//  MusicPlayer
//
//  Created by 123 on 21.01.24.
//

import Foundation
import AVKit

class AudioPlayerManager {
    static var player: AVAudioPlayer?

    static func playAudio(from url: URL) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch {
            print("Ошибка воспроизведения аудио: \(error)")
        }
    }
    
    
}

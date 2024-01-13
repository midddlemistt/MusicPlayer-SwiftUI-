//
//  SongManager.swift
//  MusicPlayer
//
//  Created by 123 on 18.01.24.
//
import Foundation
import AVKit

class SongManager: ObservableObject {
    @Published private(set) var song: SongModel = SongModel(artist: "", audio_url: "", cover: "", title: "", duration: nil)

    func playSong(song: SongModel) {
        self.song = song
        if let audioURL = Bundle.main.url(forResource: song.audio_url, withExtension: "mp3", subdirectory: "Music") {
            if let duration = getAudioDuration(from: audioURL) {
                self.song.duration = duration
                AudioPlayerManager.playAudio(from: audioURL)
            } else {
                print("Не удалось получить длительность аудио")
            }
        } else {
            print("Не удалось получить URL для аудио")
        }
    }

    private func getAudioDuration(from audioURL: URL) -> Double? {
        do {
            let audioAsset = AVURLAsset(url: audioURL)
            let duration = CMTimeGetSeconds(audioAsset.duration)
            return duration.isNaN ? nil : duration
        } catch {
            print("Ошибка при получении длительности аудио: \(error)")
            return nil
        }
    }
}


//import Foundation
//import SwiftUI
//
//class SongManager: ObservableObject {
//    @Published private(set) var song: SongModel = SongModel(artist: "", audio_url: "", cover: "", title: "")
//
//    func playSong(song: SongModel) {
//        self.song = song
//        if let audioURL = Bundle.main.url(forResource: song.audio_url, withExtension: "mp3", subdirectory: "Music") {
//            AudioPlayerManager.playAudio(from: audioURL)
//        } else {
//            print("Не удалось получить URL для аудио")
//        }
//    }
//}

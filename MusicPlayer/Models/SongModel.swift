//
//  SongModel.swift
//  MusicPlayer
//
//  Created by 123 on 17.01.24.
//

import Foundation
import SwiftUI

struct SongModel: Identifiable, Equatable {
    var id: UUID = .init()
    var artist: String
    var audio_url: String
    var cover: String
    var title: String
    var isFavourite: Bool = false
    var duration: Double?
}

var sampleSongModel: [SongModel] = [
    .init(artist: "Yung Lean", audio_url: "Yung Lean - Pearl Fountain", cover: "https://upload.wikimedia.org/wikipedia/en/1/15/Warlord_Yung_Lean.png", title: "Pearl Fountain"),
    .init(artist: "Tyler, the crator", audio_url:"Tyler, The Creator - Earfquake", cover: "https://upload.wikimedia.org/wikipedia/en/5/51/Igor_-_Tyler%2C_the_Creator.jpg", title: "EARFQUAKE"),
    .init(artist: "Homixide Gang", audio_url: "Homixide Gang - Block Work", cover: "https://i1.sndcdn.com/artworks-U7DEKCwlmoc8-0-t500x500.jpg", title: "Block Work")
]

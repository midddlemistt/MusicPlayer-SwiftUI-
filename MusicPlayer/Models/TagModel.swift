//
//  TagModel.swift
//  MusicPlayer
//
//  Created by 123 on 17.01.24.
//

import Foundation
import SwiftUI

struct TagModel : Identifiable {
    var id: UUID = .init()
    var tag: String
}

var sampleTagList: [TagModel] = [
    TagModel(tag: "Romance"),
    TagModel(tag: "Feel Good"),
    TagModel(tag: "Podcasts"),
    TagModel(tag: "Party"),
    TagModel(tag: "Relax"),
    TagModel(tag: "Commute"),
    TagModel(tag: "Workout"),
    TagModel(tag: "Sad"),
    TagModel(tag: "Romance"),
    TagModel(tag: "Focus")]

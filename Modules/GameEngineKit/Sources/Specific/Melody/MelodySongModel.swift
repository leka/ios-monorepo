// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct MelodySongModel {
    var midiFile: String  // Change to URL
    var title: String
    var colors: [Color]
    var duration: Int

    public init(midiFile: String, title: String, colors: [Color]) {
        self.midiFile = midiFile
        self.title = title
        self.colors = colors
        self.duration = colors.count

    }
}

public let kListOfMelodySongsAvailable: [MelodySongModel] = [
    MelodySongModel(midiFile: "melody_1", title: "First song title", colors: [.red, .green, .purple, .pink]),
    MelodySongModel(
        midiFile: "melody_2", title: "Second song title", colors: [.purple, .blue, .red, .pink, .red, .blue]),
    MelodySongModel(midiFile: "melody_3", title: "Third song title", colors: [.pink, .pink, .red, .red, .red, .blue]),
]

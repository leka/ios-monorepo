// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct MelodySongModel {
    let midiFile: URL
    let title: String
    let tempo: Double
    let octaveGap: UInt8

    public init(midiFile: URL, title: String, tempo: Double, octaveGap: UInt8) {
        self.midiFile = midiFile
        self.title = title
        self.tempo = tempo
        self.octaveGap = octaveGap
    }
}

public let kListOfMelodySongsAvailable: [MelodySongModel] = [
    MelodySongModel(
        midiFile: Bundle.module.url(forResource: "AuClairDeLaLune", withExtension: "mid")!,
        title: "Au Clair de la Lune",
        tempo: 200,
        octaveGap: 36
    )
]

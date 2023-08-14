// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import AudioKit
import SwiftUI

class MIDIPlayer: ObservableObject {
    let engine = AudioEngine()
    var instrument: MIDISampler

    init(name: String, samples: [MIDISample]) {
        self.instrument = MIDISampler(name: name)
        engine.output = instrument
        loadInstrument(samples: samples)
    }

    func loadInstrument(samples: [MIDISample]) {
        do {
            let files = samples.map {
                $0.audioFile!
            }
            try instrument.loadAudioFiles(files)

        } catch {
            Log("Files Didn't Load")
        }
    }

    func noteOn(number: MIDINoteNumber) {
        instrument.play(noteNumber: number, velocity: 90, channel: 0)
    }
}

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
        startAudioEngine()
        loadInstrument(samples: samples)
    }

    func startAudioEngine() {
        do {
            try engine.start()
        } catch {
            print("Could not start AudioKit")
        }
    }

    func loadInstrument(samples: [MIDISample]) {
        do {
            let files = samples.compactMap {
                $0.audioFile
            }
            try instrument.loadAudioFiles(files)
        } catch {
            print("Could not load file")
        }
    }

    func noteOn(number: MIDINoteNumber) {
        instrument.play(noteNumber: number, velocity: 60, channel: 0)
    }
}

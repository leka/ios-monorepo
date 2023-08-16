// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import AudioKit
import SwiftUI

class MIDIPlayer: ObservableObject {
    let engine = AudioEngine()
    private var instrument: MIDISampler
    private var sequencer = AppleSequencer()
    private var MIDICallback = MIDICallbackInstrument()

    init(name: String, samples: [MIDISample]) {
        self.instrument = MIDISampler(name: name)
        engine.output = instrument
        loadInstrument(samples: samples)
        try? engine.start()
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

    func loadMIDIFile(fileUrl: URL, tempo: Double) {
        sequencer.loadMIDIFile(fromURL: fileUrl)
        sequencer.setGlobalMIDIOutput(MIDICallback.midiIn)
        sequencer.setTempo(tempo)
    }

    func setMIDICallback(callback: @escaping MIDICallback) {
        MIDICallback.callback = callback
    }

    func noteOn(number: MIDINoteNumber, velocity: MIDIVelocity = 90) {
        instrument.play(noteNumber: number, velocity: velocity, channel: 0)
    }

    func play() {
        sequencer.rewind()
        sequencer.play()
    }

    func getSequenceTrack() -> [MIDINoteData] {
        sequencer.tracks[1].getMIDINoteData()
    }

    func getDuration() -> Double {
        sequencer.tracks[1].length
    }
}

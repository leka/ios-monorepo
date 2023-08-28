// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import AudioKit
import SwiftUI

class MIDIPlayer: ObservableObject {

    private let engine = AudioEngine()
    private var sampler: MIDISampler
    private var sequencer = AppleSequencer()
    private var instrument = MIDICallbackInstrument()

    init(name: String, samples: [MIDISample]) {
        self.sampler = MIDISampler(name: name)
        engine.output = sampler
        startAudioEngine()
        loadInstrument(samples: samples)
        try? engine.start()
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
            try sampler.loadAudioFiles(files)
        } catch {
            print("Could not load file")
        }
    }

    func loadMIDIFile(fileUrl: URL, tempo: Double) {
        sequencer.loadMIDIFile(fromURL: fileUrl)
        sequencer.setGlobalMIDIOutput(instrument.midiIn)
        sequencer.setTempo(tempo)
    }

    func setInstrumentCallback(callback: @escaping MIDICallback) {
        instrument.callback = callback
    }

    func noteOn(number: MIDINoteNumber, velocity: MIDIVelocity = 60) {
        sampler.play(noteNumber: number, velocity: velocity, channel: 0)
    }

    func play() {
        sequencer.rewind()
        sequencer.play()
    }

    func getMidiNotes() -> [MIDINoteData] {
        sequencer.tracks[1].getMIDINoteData()
    }

    func getDuration() -> Double {
        // TODO(@hugo): BUG - length is not correct, it returns 32 seconds but the track is ~12 secondes long
        sequencer.tracks[1].length
    }
}

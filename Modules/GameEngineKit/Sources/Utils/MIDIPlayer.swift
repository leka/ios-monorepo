// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import AudioKit
import SwiftUI

class MIDIPlayer: ObservableObject {
    public let name: String

    private let engine = AudioEngine()
    private let sampler = MIDISampler()
    private let sequencer = AppleSequencer()
    private let instrument = MIDICallbackInstrument()

    init(name: String, samples: [MIDISample]) {
        self.name = name

        engine.output = sampler

        loadInstrument(samples: samples)
        startAudioEngine()
    }

    private func startAudioEngine() {
        do {
            try engine.start()
        } catch {
            print("Could not start AudioKit")
        }
    }

    private func loadInstrument(samples: [MIDISample]) {
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

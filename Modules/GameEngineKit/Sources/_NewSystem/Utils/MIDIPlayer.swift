// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import AudioKit
import ContentKit
import SwiftUI

class MIDIPlayer: ObservableObject {
    private let engine = AudioEngine()
    private let sampler = MIDISampler()
    private let sequencer = AppleSequencer()
    private let instrument = MIDICallbackInstrument()

    init(instrument: MIDIInstrument) {
        engine.output = sampler

        loadInstrument(samples: instrument.samples)
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

    func loadMIDIFile(fileURL: URL, tempo: Double) {
        sequencer.loadMIDIFile(fromURL: fileURL)
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

    func stop() {
        sequencer.stop()
    }

    func getMidiNotes() -> [MIDINoteData] {
        guard let track = sequencer.tracks.first else {
            fatalError("Sequencer track not found")
        }

        return track.getMIDINoteData()
    }

    func getDuration() -> Double {
        guard let track = sequencer.tracks.first else {
            fatalError("Sequencer track not found")
        }

        return track.length * 60 / sequencer.tempo
    }
}

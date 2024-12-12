// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import AVFAudio
import ContentKit
import SwiftUI

class MIDIPlayer: ObservableObject {
    // MARK: Lifecycle

    init(instrument: MIDIInstrument) {
        self.engine.output = self.sampler

        self.loadInstrument(samples: instrument.samples)
        self.startAudioEngine()
    }

    // MARK: Internal

    func loadMIDIFile(fileURL: URL, tempo: Double) {
        self.sequencer.loadMIDIFile(fromURL: fileURL)
        self.sequencer.setGlobalMIDIOutput(self.instrument.midiIn)
        self.sequencer.setTempo(tempo)
    }

    func setInstrumentCallback(callback: @escaping MIDICallback) {
        self.instrument.callback = callback
    }

    func noteOn(number: MIDINoteNumber, velocity: MIDIVelocity = 60) {
        self.sampler.play(noteNumber: number, velocity: velocity, channel: 0)
    }

    func play() {
        self.sequencer.rewind()
        self.sequencer.play()
    }

    func stop() {
        self.sequencer.stop()
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

        return track.length * 60 / self.sequencer.tempo
    }

    // MARK: Private

    private let engine = AudioEngine()
    private let sampler = MIDISampler()
    private let sequencer = AppleSequencer()
    private let instrument = MIDICallbackInstrument()

    private func startAudioEngine() {
        do {
            try self.engine.start()
        } catch {
            print("Could not start AudioKit")
        }
    }

    private func loadInstrument(samples: [MIDISample]) {
        do {
            let files = samples.compactMap(\.audioFile)
            try self.sampler.loadAudioFiles(files)
        } catch {
            print("Could not load file")
        }
    }
}

// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import ContentKit
import RobotKit
import SwiftUI

extension MelodyView {
    class ViewModel: Identifiable, ObservableObject {
        // MARK: Lifecycle

        init(midiPlayer: MIDIPlayer, selectedSong: MidiRecordingPlayer.Song, shared: ExerciseSharedData? = nil) {
            self.midiPlayer = midiPlayer
            self.defaultScale = selectedSong.song.scale
            self.exercicesSharedData = shared ?? ExerciseSharedData()
            self.exercicesSharedData.state = .playing
            self.setMIDIRecording(midiRecording: selectedSong)
        }

        // MARK: Public

        @ObservedObject public var exercicesSharedData: ExerciseSharedData
        @Published public var progress: CGFloat = 0.0
        @Published public var isNotTappable: Bool = true
        @Published public var showModal: Bool = false
        @Published public var isMelodyPlaying: Bool = false
        public var midiPlayer: MIDIPlayer
        public var scale: [MIDINoteNumber] = []
        public var currentNoteNumber: MIDINoteNumber = 0

        public let defaultScale: [MIDINoteNumber]
        public let tileColors: [Robot.Color] = [.pink, .red, .orange, .yellow, .green, .lightBlue, .blue, .purple]

        // MARK: Internal

        func setMIDIRecording(midiRecording: MidiRecordingPlayer.Song) {
            let midiFile = Bundle.module.url(forResource: midiRecording.audio, withExtension: "mid")!
            self.midiPlayer.loadMIDIFile(fileURL: midiFile, tempo: self.tempo)
            self.midiNotes = self.midiPlayer.getMidiNotes()
            self.octaveGap = self.getOctaveGap(self.midiNotes.first!.noteNumber)
            self.scale = self.getScale(self.midiNotes)
            self.currentNoteNumber = self.midiNotes.first!.noteNumber - self.octaveGap
            self.setInstrumentCallback()
        }

        func playMIDIRecording() {
            self.midiPlayer.play()

            DispatchQueue.main.asyncAfter(deadline: .now() + self.midiPlayer.getDuration()) {
                self.robot.stopLights()
                self.showModal = false

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.startActivity()
                }
            }
        }

        func startActivity() {
            self.isNotTappable = false
            self.showColorFromMIDINote(self.currentNoteNumber)
        }

        func onTileTapped(noteNumber: MIDINoteNumber) {
            guard self.currentNoteIndex < self.midiNotes.count else { return }

            if noteNumber == self.currentNoteNumber {
                self.isNotTappable = true
                self.midiPlayer.noteOn(
                    number: self.currentNoteNumber, velocity: self.midiNotes[self.currentNoteIndex].velocity
                )
                self.currentNoteIndex += 1
                self.robot.stopLights()
                if self.currentNoteIndex < self.midiNotes.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.currentNoteNumber = self.midiNotes[self.currentNoteIndex].noteNumber - self.octaveGap
                        self.showColorFromMIDINote(self.currentNoteNumber)
                        self.isNotTappable = false
                    }
                } else {
                    self.robot.stopLights()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            self.isMelodyPlaying = true
                            self.showModal = true
                        }
                        self.midiPlayer.play()

                        DispatchQueue.main.asyncAfter(deadline: .now() + self.midiPlayer.getDuration()) {
                            self.exercicesSharedData.state = .completed(level: .nonApplicable)
                            self.isMelodyPlaying = false
                            self.showModal = false
                            self.robot.stopLights()
                            self.midiPlayer.stop()
                        }
                    }
                }
                self.progress = CGFloat(self.currentNoteIndex) / CGFloat(self.midiNotes.count)
            }
        }

        func showColorFromMIDINote(_ note: MIDINoteNumber) {
            guard let index = defaultScale.firstIndex(where: {
                $0 == note
            })
            else {
                fatalError("Note not found")
            }
            self.robot.shine(.all(in: self.tileColors[index]))
        }

        // MARK: Private

        private let tempo: Double = 100
        private let robot = Robot.shared
        private let defaultOctave: UInt8 = 2
        private var midiNotes: [MIDINoteData] = []
        private var currentNoteIndex: Int = 0
        private var octaveGap: MIDINoteNumber = 0

        private func setInstrumentCallback() {
            self.midiPlayer.setInstrumentCallback(callback: { _, note, velocity in
                if velocity == 0 || note < self.octaveGap { return }
                let currentNote = note - self.octaveGap
                if currentNote >= 24, currentNote <= 36 {
                    self.showColorFromMIDINote(currentNote)
                    self.midiPlayer.noteOn(number: currentNote, velocity: velocity)
                }
            })
        }

        private func getOctaveGap(_ initialNote: MIDINoteNumber) -> MIDINoteNumber {
            let initialOctave = initialNote / 12
            return (initialOctave - self.defaultOctave) * 12
        }

        private func getScale(_ notes: [MIDINoteData]) -> [MIDINoteNumber] {
            var uniqueDict: [MIDINoteNumber: MIDINoteData] = [:]

            for note in notes {
                uniqueDict[note.noteNumber - self.octaveGap] = note
            }

            return Array(uniqueDict.keys).sorted()
        }
    }
}

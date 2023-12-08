// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import ContentKit
import RobotKit
import SwiftUI

extension MelodyView {

    class ViewModel: Identifiable, ObservableObject {
        @ObservedObject public var exercicesSharedData: ExerciseSharedData
        @Published public var progress: CGFloat = 0.0
        @Published public var isNotTappable: Bool = true
        @Published public var isXylophoneBlurred: Bool = false
        public var midiPlayer: MIDIPlayer
        public var scale: [MIDINoteNumber] = []
        public var currentNoteNumber: MIDINoteNumber = 0

        public let defaultScale: [MIDINoteNumber]
        public let tileColors: [Robot.Color] = [.pink, .red, .orange, .yellow, .green, .lightBlue, .blue, .purple]
        private let tempo: Double = 100
        private let robot = Robot.shared
        private let defaultOctave: UInt8 = 2
        private var midiNotes: [MIDINoteData] = []
        private var currentNoteIndex: Int = 0
        private var octaveGap: MIDINoteNumber = 0

        init(
            midiPlayer: MIDIPlayer, selectedSong: MidiRecording,
            shared: ExerciseSharedData? = nil
        ) {
            self.midiPlayer = midiPlayer
            self.defaultScale = selectedSong.scale
            self.exercicesSharedData = shared ?? ExerciseSharedData()
            self.exercicesSharedData.state = .playing
            self.setMIDIRecording(midiRecording: selectedSong)
        }

        func setMIDIRecording(midiRecording: MidiRecording) {
            let midiFile = Bundle.module.url(forResource: midiRecording.file, withExtension: "mid")!
            self.midiPlayer.loadMIDIFile(fileUrl: midiFile, tempo: tempo)
            self.midiNotes = midiPlayer.getMidiNotes()
            self.octaveGap = getOctaveGap(midiNotes.first!.noteNumber)
            self.scale = getScale(midiNotes)
            self.currentNoteNumber = midiNotes.first!.noteNumber - self.octaveGap
            setInstrumentCallback()
        }

        func playMIDIRecording() {
            midiPlayer.play()

            DispatchQueue.main.asyncAfter(deadline: .now() + self.midiPlayer.getDuration()) {
                self.robot.stopLights()
                self.isXylophoneBlurred = false

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.startActivity()
                }
            }
        }

        func startActivity() {
            progress = 0.0
            isNotTappable = false
            showColorFromMIDINote(self.currentNoteNumber)
        }

        func onTileTapped(noteNumber: MIDINoteNumber) {
            guard currentNoteIndex < midiNotes.count else { return }

            if noteNumber == currentNoteNumber {
                isNotTappable = true
                midiPlayer.noteOn(
                    number: currentNoteNumber, velocity: midiNotes[currentNoteIndex].velocity)
                currentNoteIndex += 1
                robot.stopLights()
                if currentNoteIndex < midiNotes.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.currentNoteNumber = self.midiNotes[self.currentNoteIndex].noteNumber - self.octaveGap
                        self.showColorFromMIDINote(self.currentNoteNumber)
                        self.isNotTappable = false
                    }
                } else {
                    robot.stopLights()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.midiPlayer.play()

                        DispatchQueue.main.asyncAfter(deadline: .now() + self.midiPlayer.getDuration()) {
                            self.exercicesSharedData.state = .completed
                            self.robot.stopLights()
                            self.midiPlayer.stop()
                        }
                    }
                }
                progress = CGFloat(currentNoteIndex) / CGFloat(midiNotes.count)
            }
        }

        private func setInstrumentCallback() {
            var currentNoteIndex = 0
            self.midiPlayer.setInstrumentCallback(callback: { _, note, velocity in
                if velocity == 0 || note < self.octaveGap { return }
                let currentNote = note - self.octaveGap
                if 24 <= currentNote && currentNote <= 36 {
                    currentNoteIndex += 1
                    withAnimation {
                        self.progress = CGFloat(currentNoteIndex) / CGFloat(self.midiNotes.count)
                    }
                    self.showColorFromMIDINote(currentNote)
                    self.midiPlayer.noteOn(number: currentNote, velocity: velocity)
                }
            })
        }

        private func getOctaveGap(_ initialNote: MIDINoteNumber) -> MIDINoteNumber {
            let initialOctave = initialNote / 12
            return (initialOctave - defaultOctave) * 12
        }

        private func getScale(_ notes: [MIDINoteData]) -> [MIDINoteNumber] {
            var uniqueDict: [MIDINoteNumber: MIDINoteData] = [:]

            for note in notes {
                uniqueDict[note.noteNumber - self.octaveGap] = note
            }

            return Array(uniqueDict.keys).sorted()
        }

        func showColorFromMIDINote(_ note: MIDINoteNumber) {
            guard
                let index = defaultScale.firstIndex(where: {
                    $0 == note
                })
            else {
                fatalError("Note not found")
            }
            robot.shine(.all(in: tileColors[index]))
        }
    }

}

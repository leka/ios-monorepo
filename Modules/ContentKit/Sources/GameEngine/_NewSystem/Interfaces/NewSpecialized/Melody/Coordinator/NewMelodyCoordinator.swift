// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import Combine
import RobotKit
import SwiftUI

// MARK: - NewMelodyCoordinator

class NewMelodyCoordinator: ExerciseSharedDataProtocol {
    // MARK: Lifecycle

    public init(instrument: MIDIInstrument, songs: [MidiRecordingPlayerSong]) {
        self.midiPlayer = MIDIPlayer(instrument: instrument)
        self.instrument = instrument
        self.songs = songs
    }

    public convenience init(model: NewMelodyModel) {
        self.init(instrument: model.instrument, songs: model.songs)
    }

    // MARK: Public

    public private(set) var progress = CurrentValueSubject<CGFloat, Never>(0.0)
    public private(set) var scale = CurrentValueSubject<[MIDINoteNumber], Never>([])
    public private(set) var showPlayButton = CurrentValueSubject<Bool, Never>(false)
    public private(set) var enableTap = CurrentValueSubject<Bool, Never>(false)
    public private(set) var isMelodyPlaying = CurrentValueSubject<Bool, Never>(false)

    // MARK: Internal

    let songs: [MidiRecordingPlayerSong]
    var selectedSong: MidiRecordingPlayerSong?
    var instrument: MIDIInstrument
    var midiPlayer: MIDIPlayer
    var currentNoteNumber: MIDINoteNumber = 0
    let tileColors: [Robot.Color] = [.pink, .red, .orange, .yellow, .green, .lightBlue, .blue, .purple]

    var didComplete: PassthroughSubject<Void, Never> = .init()

    func setupMelody(midiRecording: MidiRecordingPlayerSong) {
        guard self.selectedSong != midiRecording else { return }

        self.selectedSong = midiRecording
        let midiFile = Bundle.module.url(forResource: midiRecording.audio, withExtension: "mid")!
        self.currentNoteIndex = 0
        self.progress.send(0.0)
        self.isMelodyPlaying.send(false)
        self.midiPlayer.loadMIDIFile(fileURL: midiFile, tempo: self.kTempo)
        self.midiNotes = self.midiPlayer.getMidiNotes()
        self.octaveGap = self.getOctaveGap(self.midiNotes.first!.noteNumber)
        self.scale.send(self.getScale(self.midiNotes))
        self.currentNoteNumber = self.midiNotes.first!.noteNumber - self.octaveGap
        self.showPlayButton.send(true)
        self.setInstrumentCallback()
    }

    func playMIDIRecording() {
        self.midiPlayer.play()

        DispatchQueue.main.asyncAfter(deadline: .now() + self.midiPlayer.getDuration()) {
            self.robot.stopLights()
            self.showPlayButton.send(false)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.startActivity()
            }
        }
    }

    func startActivity() {
        self.enableTap.send(true)
        self.showColorFromMIDINote(self.currentNoteNumber)
    }

    func stop() {
        self.midiPlayer.stop()
    }

    func onTileTapped(noteNumber: MIDINoteNumber) {
        guard self.currentNoteIndex < self.midiNotes.count else { return }

        if noteNumber == self.currentNoteNumber {
            self.enableTap.send(false)
            self.midiPlayer.noteOn(
                number: self.currentNoteNumber, velocity: self.midiNotes[self.currentNoteIndex].velocity
            )
            self.currentNoteIndex += 1
            self.robot.stopLights()
            if self.currentNoteIndex < self.midiNotes.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.currentNoteNumber = self.midiNotes[self.currentNoteIndex].noteNumber - self.octaveGap
                    self.showColorFromMIDINote(self.currentNoteNumber)
                    self.enableTap.send(true)
                }
            } else {
                self.robot.stopLights()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.isMelodyPlaying.send(true)
                        self.showPlayButton.send(true)
                    }
                    self.midiPlayer.play()

                    DispatchQueue.main.asyncAfter(deadline: .now() + self.midiPlayer.getDuration()) {
                        // TODO: (@ladislas, @HPezz) Trigger didComplete on animation ended
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            logGEK.debug("Exercise completed")
                            self.didComplete.send()
                        }
                        self.isMelodyPlaying.send(false)
                        self.showPlayButton.send(false)
                        self.robot.stopLights()
                        self.midiPlayer.stop()
                    }
                }
            }
            self.progress.send(CGFloat(self.currentNoteIndex) / CGFloat(self.midiNotes.count))
        }
    }

    // MARK: Private

    private let kTempo: Double = 100
    private let kDefaultOctave: UInt8 = 2
    private let robot = Robot.shared
    private var midiNotes: [MIDINoteData] = []
    private var currentNoteIndex: Int = 0
    private var octaveGap: MIDINoteNumber = 0

    private func showColorFromMIDINote(_ note: MIDINoteNumber) {
        guard let index = self.scale.value.firstIndex(where: {
            $0 == note
        })
        else {
            fatalError("Note not found")
        }
        self.robot.shine(.all(in: self.tileColors[index]))
    }

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
        return (initialOctave - self.kDefaultOctave) * 12
    }

    private func getScale(_ notes: [MIDINoteData]) -> [MIDINoteNumber] {
        var uniqueDict: [MIDINoteNumber: MIDINoteData] = [:]

        for note in notes {
            uniqueDict[note.noteNumber - self.octaveGap] = note
        }

        return Array(uniqueDict.keys).sorted()
    }
}

#Preview {
    let songs = [
        MidiRecordingPlayerSong(song: "Under_The_Moonlight"),
        MidiRecordingPlayerSong(song: "A_Green_Mouse"),
        MidiRecordingPlayerSong(song: "Twinkle_Twinkle_Little_Star"),
        MidiRecordingPlayerSong(song: "Oh_The_Crocodiles"),
        MidiRecordingPlayerSong(song: "Happy_Birthday"),
    ]
    let coordinator = NewMelodyCoordinator(instrument: .xylophone, songs: songs)
    let viewModel = NewMelodyViewViewModel(coordinator: coordinator)

    return NewMelodyView(viewModel: viewModel)
}

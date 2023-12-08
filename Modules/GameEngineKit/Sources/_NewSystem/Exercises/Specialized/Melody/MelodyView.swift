// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import ContentKit
import SwiftUI

struct MelodyView: View {

    enum Stage {
        case waitingForSelection
        case selectionConfirmed
    }

    enum Keyboard {
        case full
        case partial
    }

    @State private var mode = Stage.waitingForSelection
    @State private var selectedSong: MidiRecording
    @State private var keyboard: Keyboard = .partial
    let data: ExerciseSharedData?
    let instructions: MidiRecordingPlayer.Payload.Instructions
    let instrument: MIDIInstrument
    let songs: [MidiRecording]

    init(instructions: MidiRecordingPlayer.Payload.Instructions, instrument: MIDIInstrument, songs: [MidiRecording]) {
        self.instructions = instructions
        self.instrument = instrument
        self.songs = songs
        self.selectedSong = songs.first!
        self.data = nil
    }

    init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? MidiRecordingPlayer.Payload else {
            fatalError("Exercise payload is not .instrument")
        }

        guard let instrument = MIDIInstrument(rawValue: payload.instrument)
        else {
            fatalError("Instrument or song not found")
        }

        self.instructions = payload.instructions
        self.instrument = instrument
        self.songs = payload.songs
        self.selectedSong = songs.first!
        self.data = data
    }

    var body: some View {
        NavigationStack {
            switch mode {
                case .waitingForSelection:
                    LauncherView(
                        selectedSong: $selectedSong, mode: $mode, keyboard: $keyboard, songs: songs,
                        instructions: instructions)
                case .selectionConfirmed:
                    switch instrument {
                        case .xylophone:
                            XylophoneView(
                                instrument: instrument, selectedSong: selectedSong, keyboard: keyboard,
                                instructions: instructions, data: data)
                    }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    let instructions = MidiRecordingPlayer.Payload.Instructions(
        textMusicSelection: "Sélection de la musique",
        textButtonPlay: "Jouer",
        textKeyboardPartial: "Clavier partiel",
        textKeyboardFull: "Clavier entier",
        textStartMelody: "Appuie sur le bouton Play pour écouter et voir Leka jouer de la musique!",
        textSkipMelody: "Passer la chanson"
    )

    return MelodyView(instructions: instructions, instrument: .xylophone, songs: [MidiRecording(.underTheMoonlight)])
}

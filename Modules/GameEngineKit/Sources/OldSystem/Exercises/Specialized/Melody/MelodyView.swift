// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import ContentKit
import SwiftUI

public struct MelodyView: View {
    // MARK: Lifecycle

    init(instrument: MIDIInstrument, songs: [MidiRecordingPlayer.Song]) {
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

        self.instrument = instrument
        self.songs = payload.songs
        self.selectedSong = self.songs.first!
        self.data = data
    }

    // MARK: Public

    public var body: some View {
        NavigationStack {
            switch self.mode {
                case .waitingForSelection:
                    LauncherView(
                        selectedSong: self.$selectedSong, mode: self.$mode, keyboard: self.$keyboard, songs: self.songs
                    )
                case .selectionConfirmed:
                    switch self.instrument {
                        case .xylophone:
                            XylophoneView(
                                instrument: self.instrument, selectedSong: self.selectedSong, keyboard: self.keyboard, data: self.data
                            )
                    }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: Internal

    enum Stage {
        case waitingForSelection
        case selectionConfirmed
    }

    enum KeyboardType {
        case full
        case partial
    }

    let data: ExerciseSharedData?
    let instrument: MIDIInstrument
    let songs: [MidiRecordingPlayer.Song]

    // MARK: Private

    @State private var mode = Stage.waitingForSelection
    @State private var selectedSong: MidiRecordingPlayer.Song
    @State private var keyboard: KeyboardType = .partial
}

#Preview {
    MelodyView(
        instrument: .xylophone,
        songs: [MidiRecordingPlayer.Song(song: "Under_The_Moonlight")]
    )
}

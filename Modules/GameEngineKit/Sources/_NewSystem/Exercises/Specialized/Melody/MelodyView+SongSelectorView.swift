// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import SwiftUI

extension MelodyView {
    struct SongSelectorView: View {
        // MARK: Lifecycle

        init(songs: [MidiRecording], selectedMidiRecording: Binding<MidiRecording>, textMusicSelection: String) {
            self.songs = songs
            self._selectedMidiRecording = selectedMidiRecording
            self.textMusicSelection = textMusicSelection
        }

        // MARK: Internal

        @Binding var selectedMidiRecording: MidiRecording
        let songs: [MidiRecording]
        let textMusicSelection: String

        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]

        var body: some View {
            VStack(alignment: .leading) {
                Text(self.textMusicSelection)
                    .font(.headline)

                Divider()

                ScrollView {
                    LazyVGrid(columns: self.columns, alignment: .leading, spacing: 20) {
                        ForEach(self.songs, id: \.self) { midiRecording in
                            HStack {
                                Image(
                                    systemName: midiRecording == self.selectedMidiRecording
                                        ? "checkmark.circle.fill" : "circle"
                                )
                                .imageScale(.large)
                                .foregroundColor(
                                    midiRecording == self.selectedMidiRecording
                                        ? .green : .primary
                                )
                                Text(midiRecording.name)
                            }
                            .onTapGesture {
                                withAnimation {
                                    self.selectedMidiRecording = midiRecording
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    let songs = [
        MidiRecording(.aGreenMouse),
        MidiRecording(.londonBridgeIsFallingDown),
        MidiRecording(.twinkleTwinkleLittleStar),
        MidiRecording(.underTheMoonlight),
    ]
    let instructions = MidiRecordingPlayer.Payload.Instructions(
        textMusicSelection: "Sélection de la musique",
        textButtonPlay: "Jouer",
        textKeyboardPartial: "Clavier partiel",
        textKeyboardFull: "Clavier entier"
    )

    return MelodyView.SongSelectorView(
        songs: songs,
        selectedMidiRecording: .constant(MidiRecording(.underTheMoonlight)),
        textMusicSelection: instructions.textMusicSelection
    )
}

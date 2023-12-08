// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import SwiftUI

extension MelodyView {

    struct SongSelectorView: View {
        @Binding var selectedMidiRecording: MidiRecording
        let songs: [MidiRecording]
        let textMusicSelection: String

        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]

        init(songs: [MidiRecording], selectedMidiRecording: Binding<MidiRecording>, textMusicSelection: String) {
            self.songs = songs
            self._selectedMidiRecording = selectedMidiRecording
            self.textMusicSelection = textMusicSelection
        }

        var body: some View {

            VStack {
                HStack {
                    Image(systemName: "music.note.list")
                    Text(textMusicSelection)
                    Image(systemName: "music.note.list")
                }

                Divider()

                ScrollView {
                    LazyVGrid(columns: columns, alignment: .listRowSeparatorLeading, spacing: 20) {
                        ForEach(songs, id: \.self) { midiRecording in
                            Button {
                                selectedMidiRecording = midiRecording
                            } label: {
                                HStack {
                                    Image(
                                        systemName: midiRecording == selectedMidiRecording
                                            ? "checkmark.circle.fill" : "circle"
                                    )
                                    .imageScale(.large)
                                    .foregroundColor(
                                        midiRecording == selectedMidiRecording
                                            ? .green : DesignKitAsset.Colors.lekaDarkGray.swiftUIColor
                                    )
                                    Text(midiRecording.name)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 50)
            .background(.white)
            .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
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
        textKeyboardFull: "Clavier entier",
        textStartMelody: "Appuie sur le bouton Play pour écouter et voir Leka jouer de la musique!",
        textSkipMelody: "Passer la chanson"
    )

    return MelodyView.SongSelectorView(
        songs: songs,
        selectedMidiRecording: .constant(MidiRecording(.underTheMoonlight)),
        textMusicSelection: instructions.textMusicSelection
    )
}

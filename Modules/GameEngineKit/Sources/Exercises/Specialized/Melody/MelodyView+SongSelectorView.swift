// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

extension MelodyView {
    struct SongSelectorView: View {
        // MARK: Lifecycle

        init(songs: [MidiRecording], selectedMidiRecording: Binding<MidiRecording>) {
            self.songs = songs
            self._selectedMidiRecording = selectedMidiRecording
        }

        // MARK: Internal

        @Binding var selectedMidiRecording: MidiRecording
        let songs: [MidiRecording]

        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]

        var body: some View {
            VStack(alignment: .leading) {
                Text(l10n.MelodyView.musicSelectionTitle)
                    .font(.headline)

                Divider()

                ScrollView {
                    LazyVGrid(columns: self.columns, alignment: .leading, spacing: 20) {
                        ForEach(self.songs, id: \.self) { midiRecording in
                            Label(midiRecording.name, systemImage: midiRecording == self.selectedMidiRecording
                                ? "checkmark.circle.fill" : "circle")
                                .imageScale(.large)
                                .foregroundColor(
                                    midiRecording == self.selectedMidiRecording
                                        ? .green : .primary
                                )
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

    return MelodyView.SongSelectorView(
        songs: songs,
        selectedMidiRecording: .constant(MidiRecording(.underTheMoonlight))
    )
}

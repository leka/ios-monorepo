// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

extension DanceFreezeView {
    struct SongSelectorView: View {
        // MARK: Lifecycle

        init(songs: [AudioRecording], selectedAudioRecording: Binding<AudioRecording>) {
            self.songs = songs
            self._selectedAudioRecording = selectedAudioRecording
        }

        // MARK: Internal

        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]

        @Binding var selectedAudioRecording: AudioRecording
        let songs: [AudioRecording]

        var body: some View {
            VStack(alignment: .leading) {
                Text(l10n.DanceFreezeView.musicSelectionTitle)
                    .font(.headline)

                Divider()

                ScrollView {
                    LazyVGrid(columns: self.columns, alignment: .leading, spacing: 20) {
                        ForEach(self.songs, id: \.self) { audioRecording in
                            Label(audioRecording.name, systemImage: audioRecording == self.selectedAudioRecording
                                ? "checkmark.circle.fill" : "circle")
                                .imageScale(.large)
                                .foregroundColor(
                                    audioRecording == self.selectedAudioRecording
                                        ? .green : .primary
                                )
                                .onTapGesture {
                                    withAnimation {
                                        self.selectedAudioRecording = audioRecording
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
        AudioRecording(name: "Giggly Squirrel", file: "Giggly_Squirrel"),
        AudioRecording(name: "Empty Page", file: "Empty_Page"),
        AudioRecording(name: "Early Bird", file: "Early_Bird"),
        AudioRecording(name: "Hands On", file: "Hands_On"),
        AudioRecording(name: "In The Game", file: "In_The_Game"),
        AudioRecording(name: "Little by Little", file: "Little_by_little"),
    ]

    return DanceFreezeView.SongSelectorView(
        songs: songs,
        selectedAudioRecording: .constant(AudioRecording(.emptyPage))
    )
}

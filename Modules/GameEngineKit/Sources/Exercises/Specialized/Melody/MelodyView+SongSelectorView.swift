// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import SVGView
import SwiftUI

extension MelodyView {
    struct SongSelectorView: View {
        // MARK: Lifecycle

        init(songs: [MidiRecordingPlayer.Song], selectedMidiRecording: Binding<MidiRecordingPlayer.Song>) {
            self.songs = songs
            self._selectedMidiRecording = selectedMidiRecording
        }

        // MARK: Internal

        @Binding var selectedMidiRecording: MidiRecordingPlayer.Song
        let songs: [MidiRecordingPlayer.Song]

        let columns = [
            GridItem(.flexible(), alignment: .topLeading),
            GridItem(.flexible(), alignment: .topLeading),
        ]

        var body: some View {
            VStack(alignment: .leading) {
                Text(l10n.MelodyView.musicSelectionTitle)
                    .font(.headline)

                Divider()

                ScrollView {
                    LazyVGrid(columns: self.columns, alignment: .leading) {
                        ForEach(self.songs, id: \.self) { midiRecording in
                            ListRowSong(image: midiRecording.labels.icon, text: midiRecording.labels.name)
                                .foregroundColor(
                                    midiRecording == self.selectedMidiRecording
                                        ? self.styleManager.accentColor! : .primary
                                )
                                .onTapGesture {
                                    withAnimation {
                                        self.selectedMidiRecording = midiRecording
                                    }
                                }
                        }
                    }
                }
            }
            .padding(.horizontal, 40)
        }

        // MARK: Private

        @ObservedObject private var styleManager: StyleManager = .shared
    }

    private struct ListRowSong: View {
        // MARK: Lifecycle

        init(image: String, text: String) {
            if let path = Bundle.path(forImage: image) {
                self.image = path
            } else {
                self.image = image
            }
            self.text = text
        }

        // MARK: Internal

        let image: String
        let text: String

        var body: some View {
            HStack {
                if self.image.isRasterImageFile {
                    Image(uiImage: UIImage(named: self.image)!)
                        .resizable()
                        .scaledToFit()
                } else if self.image.isVectorImageFile {
                    SVGView(contentsOf: URL(fileURLWithPath: self.image))
                        .scaledToFit()
                }
                Text(self.text)
                    .font(.body.bold())
            }
            .frame(maxHeight: 60)
        }
    }
}

#Preview {
    MelodyView.SongSelectorView(
        songs: [
            MidiRecordingPlayer.Song(song: "Under_The_Moonlight"),
            MidiRecordingPlayer.Song(song: "A_Green_Mouse"),
            MidiRecordingPlayer.Song(song: "Twinkle_Twinkle_Little_Star"),
        ],
        selectedMidiRecording: .constant(MidiRecordingPlayer.Song(song: "Under_The_Moonlight"))
    )
}

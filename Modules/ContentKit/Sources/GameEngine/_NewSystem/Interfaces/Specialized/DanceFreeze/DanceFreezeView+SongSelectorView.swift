// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SVGView
import SwiftUI

extension DanceFreezeView {
    struct SongSelectorView: View {
        // MARK: Lifecycle

        init(songs: [DanceFreeze.Song], selectedAudioRecording: Binding<DanceFreeze.Song>) {
            self.songs = songs
            self._selectedAudioRecording = selectedAudioRecording
        }

        // MARK: Internal

        @Binding var selectedAudioRecording: DanceFreeze.Song

        let columns = [
            GridItem(.flexible(), alignment: .topLeading),
            GridItem(.flexible(), alignment: .topLeading),
        ]

        let songs: [DanceFreeze.Song]

        var body: some View {
            VStack(alignment: .leading) {
                Text(l10n.DanceFreezeView.musicSelectionTitle)
                    .font(.headline)

                Divider()

                ScrollView {
                    LazyVGrid(columns: self.columns, alignment: .leading) {
                        ForEach(self.songs, id: \.self) { audioRecording in
                            ListRowSong(audioRecording: audioRecording, isSelected: audioRecording == self.selectedAudioRecording)
                                .foregroundColor(
                                    audioRecording == self.selectedAudioRecording
                                        ? self.styleManager.accentColor! : .primary
                                )
                                .onTapGesture {
                                    withAnimation {
                                        self.selectedAudioRecording = audioRecording
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

        init(audioRecording: DanceFreeze.Song, isSelected: Bool) {
            guard let image = Bundle.path(forImage: audioRecording.labels.icon) else {
                fatalError("Image not found")
            }
            self.image = image
            self.text = audioRecording.labels.name
            self.isSelected = isSelected
        }

        // MARK: Internal

        let image: String
        let text: String
        let isSelected: Bool

        var body: some View {
            HStack {
                Image(systemName: self.isSelected ? "checkmark.circle.fill" : "circle")
                    .imageScale(.large)
                if self.image.isRasterImageFile {
                    Image(uiImage: UIImage(named: self.image)!)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 100)
                } else if self.image.isVectorImageFile {
                    SVGView(contentsOf: URL(fileURLWithPath: self.image))
                        .scaledToFit()
                        .frame(maxWidth: 100)
                }
                Text(self.text)
            }
            .frame(maxHeight: 150)
        }
    }
}

#Preview {
    DanceFreezeView.SongSelectorView(
        songs: [
            DanceFreeze.Song(song: "Giggly_Squirrel"),
            DanceFreeze.Song(song: "Empty_Page"),
            DanceFreeze.Song(song: "Early_Bird"),
            DanceFreeze.Song(song: "Hands_On"),
            DanceFreeze.Song(song: "In_The_Game"),
            DanceFreeze.Song(song: "Little_by_little"),
        ],
        selectedAudioRecording: .constant(DanceFreeze.Song(song: "Empty_Page"))
    )
}

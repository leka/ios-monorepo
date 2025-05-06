// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SVGView
import SwiftUI

struct DanceFreezeSongSelectorView: View {
    // MARK: Lifecycle

    init(songs: [DanceFreezeSong], selectedAudioRecording: Binding<DanceFreezeSong>) {
        self.songs = songs
        self._selectedAudioRecording = selectedAudioRecording
    }

    // MARK: Internal

    @Binding var selectedAudioRecording: DanceFreezeSong

    let columns = [
        GridItem(.flexible(), alignment: .topLeading),
        GridItem(.flexible(), alignment: .topLeading),
    ]

    let songs: [DanceFreezeSong]

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

    private struct ListRowSong: View {
        // MARK: Lifecycle

        init(audioRecording: DanceFreezeSong, isSelected: Bool) {
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

    private var styleManager: StyleManager = .shared
}

#Preview {
    let songs = [
        DanceFreezeSong(song: "Giggly_Squirrel"),
        DanceFreezeSong(song: "Empty_Page"),
        DanceFreezeSong(song: "Early_Bird"),
        DanceFreezeSong(song: "Hands_On"),
        DanceFreezeSong(song: "In_The_Game"),
        DanceFreezeSong(song: "Little_by_little"),
    ]
    DanceFreezeSongSelectorView(
        songs: songs,
        selectedAudioRecording: .constant(DanceFreezeSong(song: "Empty_Page"))
    )
}

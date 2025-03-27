// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SVGView
import SwiftUI

// MARK: - MelodySongSelectorView

struct MelodySongSelectorView: View {
    // MARK: Lifecycle

    init(songs: [MidiRecordingPlayerSong], selectedMidiRecording: Binding<MidiRecordingPlayerSong>) {
        self.songs = songs
        self._selectedMidiRecording = selectedMidiRecording
    }

    // MARK: Internal

    @Binding var selectedMidiRecording: MidiRecordingPlayerSong

    let songs: [MidiRecordingPlayerSong]

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
                        ListRowSong(midiRecording: midiRecording, isSelected: midiRecording == self.selectedMidiRecording)
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
    }

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared
}

// MARK: - ListRowSong

private struct ListRowSong: View {
    // MARK: Lifecycle

    init(midiRecording: MidiRecordingPlayerSong, isSelected: Bool) {
        guard let image = Bundle.path(forImage: midiRecording.labels.icon) else {
            fatalError("Image not found")
        }
        self.image = image
        self.text = midiRecording.labels.name
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
    }
}

#Preview {
    MelodySongSelectorView(
        songs: [
            MidiRecordingPlayerSong(song: "Under_The_Moonlight"),
            MidiRecordingPlayerSong(song: "A_Green_Mouse"),
            MidiRecordingPlayerSong(song: "Twinkle_Twinkle_Little_Star"),
        ],
        selectedMidiRecording: .constant(MidiRecordingPlayerSong(song: "Under_The_Moonlight"))
    )
}

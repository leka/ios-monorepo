// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SVGView
import SwiftUI

// MARK: - DanceFreezeSongSelectorView

struct DanceFreezeSongSelectorView: View {
    // MARK: Lifecycle

    init(songs: [DanceFreezeSong], selectedAudioRecording: Binding<DanceFreezeSong>) {
        self.songs = songs
        self._selectedAudioRecording = selectedAudioRecording
    }

    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    @Binding var selectedAudioRecording: DanceFreezeSong

    let columns = [
        GridItem(.flexible(), alignment: .topLeading),
        GridItem(.flexible(), alignment: .topLeading),
    ]

    let songs: [DanceFreezeSong]

    var body: some View {
        NavigationStack {
            ScrollView {
                ContentKitAsset.Exercises.DanceFreeze.imageIllustration.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .padding(.bottom, 50)

                LazyVGrid(columns: self.columns, alignment: .center) {
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
                .padding(.horizontal, 50)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(l10n.DanceFreezeSongSelectorView.selectorTitle)
                        .font(.body.bold())
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.dismiss()
                    } label: {
                        Text(l10n.DanceFreezeSongSelectorView.confirmButtonLabel)
                    }
                }
            }
            .interactiveDismissDisabled()
        }
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

// MARK: - l10n.DanceFreezeSongSelectorView

extension l10n {
    enum DanceFreezeSongSelectorView {
        static let selectorTitle = LocalizedString("game_engine_kit.dance_freeze_song_selector_view.selector_title",
                                                   bundle: ContentKitResources.bundle,
                                                   value: "Select your song",
                                                   comment: "Selector song title in DanceFreeze")

        static let confirmButtonLabel = LocalizedString("game_engine_kit.dance_freeze_song_selector_view.confirm_button_label",
                                                        bundle: ContentKitResources.bundle,
                                                        value: "Confirm",
                                                        comment: "Confirm button label for song selector sheet in DanceFreeze")
    }
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

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

    init(viewModel: NewMelodyViewViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    let viewModel: NewMelodyViewViewModel

    let columns = [
        GridItem(.flexible(), alignment: .topLeading),
        GridItem(.flexible(), alignment: .topLeading),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                ContentKitAsset.Exercises.Melody.imageIllustration.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .padding(.bottom, 50)

                LazyVGrid(columns: self.columns, alignment: .center) {
                    ForEach(self.viewModel.songs, id: \.self) { midiRecording in
                        ListRowSong(midiRecording: midiRecording, isSelected: midiRecording == self.viewModel.selectedSong)
                            .foregroundColor(
                                midiRecording == self.viewModel.selectedSong
                                    ? self.styleManager.accentColor! : .primary
                            )
                            .onTapGesture {
                                withAnimation {
                                    self.viewModel.selectedSong = midiRecording
                                }
                            }
                    }
                }
                .padding(.horizontal, 50)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(l10n.MelodySongSelectorView.selectorTitle)
                        .font(.body.bold())
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.dismiss()
                    } label: {
                        Text(l10n.MelodySongSelectorView.confirmButtonLabel)
                    }
                }
            }
            .interactiveDismissDisabled()
        }
    }

    // MARK: Private

    private var styleManager: StyleManager = .shared
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

// MARK: - l10n.MelodySongSelectorView

extension l10n {
    enum MelodySongSelectorView {
        static let selectorTitle = LocalizedString("game_engine_kit.melody_song_selector_view.selector_title",
                                                   bundle: ContentKitResources.bundle,
                                                   value: "Select your song",
                                                   comment: "Selector song title in DanceFreeze")

        static let confirmButtonLabel = LocalizedString("game_engine_kit.melody_song_selector_view.confirm_button_label",
                                                        bundle: ContentKitResources.bundle,
                                                        value: "Confirm",
                                                        comment: "Confirm button label for song selector sheet in DanceFreeze")
    }
}

#Preview {
    let songs = [
        MidiRecordingPlayerSong(song: "Under_The_Moonlight"),
        MidiRecordingPlayerSong(song: "A_Green_Mouse"),
        MidiRecordingPlayerSong(song: "Twinkle_Twinkle_Little_Star"),
        MidiRecordingPlayerSong(song: "Oh_The_Crocodiles"),
        MidiRecordingPlayerSong(song: "Happy_Birthday"),
    ]

    let coordinator = NewMelodyCoordinator(instrument: .xylophone, songs: songs)
    let viewModel = NewMelodyViewViewModel(coordinator: coordinator)

    Text("Empty View")
        .sheet(isPresented: .constant(true)) {
            MelodySongSelectorView(viewModel: viewModel)
        }
}

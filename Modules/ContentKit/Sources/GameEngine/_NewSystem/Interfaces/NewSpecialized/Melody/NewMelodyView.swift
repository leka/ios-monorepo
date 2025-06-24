// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import LocalizationKit
import SwiftUI

// MARK: - MelodyKeyboardType

enum MelodyKeyboardType {
    case full
    case partial
}

// MARK: - NewMelodyView

public struct NewMelodyView: View {
    // MARK: Public

    public var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button {
                    self.isMusicSelectorPresented = true
                    self.viewModel.stop()
                } label: {
                    Label(String(l10n.NewMelodyView.changeMusicButtonLabel.characters), systemImage: "music.quarternote.3")
                }
                .padding(20)
                .background(Capsule().fill(.background).shadow(radius: 3))

                Toggle(isOn: self.$isKeyboardFull) {
                    HStack(alignment: .center) {
                        ContentKitAsset.Exercises.Melody.iconKeyboardFull.swiftUIImage
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text(l10n.NewMelodyView.fullKeyboardToggleLabel)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .opacity(self.viewModel.progress == 1.0 ? 0.5 : 1.0)
            .disabled(self.viewModel.progress == 1.0)
            .padding(.horizontal, 300)
            .padding(.vertical)

            ContinuousProgressBar(progress: self.viewModel.progress)
                .animation(.easeOut, value: self.viewModel.progress)
                .padding()

            MelodyXylophoneView(viewModel: self.viewModel)
                .padding(.vertical, 50)
        }
        .onChange(of: self.isKeyboardFull) {
            self.viewModel.updateKeyboardMode(isKeyboardFull: self.isKeyboardFull)
        }
        .sheet(isPresented: self.$isMusicSelectorPresented) {
            MelodySongSelectorView(viewModel: self.viewModel)
                .onDisappear {
                    self.viewModel.setup()
                }
        }
        .onDisappear {
            self.viewModel.stop()
        }
    }

    // MARK: Private

    @State private var isKeyboardFull: Bool = false
    @State private var isMusicSelectorPresented: Bool = true
    @State var viewModel: NewMelodyViewViewModel
}

// MARK: - l10n.NewMelodyView

extension l10n {
    enum NewMelodyView {
        static let changeMusicButtonLabel = LocalizedString("game_engine_kit.new_melody_view.change_music_button_label",
                                                            bundle: ContentKitResources.bundle,
                                                            value: "Change music",
                                                            comment: "Label of button that changes music in Melody")

        static let fullKeyboardToggleLabel = LocalizedString("game_engine_kit.new_melody_view.full_keyboard_toggle_label",
                                                             bundle: ContentKitResources.bundle,
                                                             value: "Full keyboard",
                                                             comment: "Label of toggle that switch on/off full keyboard in Melody")
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
    return NewMelodyView(viewModel: viewModel)
}

// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import ContentKit
import LocalizationKit
import RobotKit
import SwiftUI

struct MelodyXylophoneView: View {
    // MARK: Lifecycle

    init(viewModel: NewMelodyViewViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Public

    public var body: some View {
        ZStack {
            VStack(spacing: 50) {
                ContinuousProgressBar(progress: self.viewModel.progress)
                    .animation(.easeOut, value: self.viewModel.progress)
                    .padding(.horizontal)

                HStack(spacing: self.kTilesSpacing) {
                    ForEach(self.viewModel.selectedSong.song.scale.enumerated().map { $0 }, id: \.0) { index, note in
                        Button {
                            self.viewModel.onTileTapped(noteNumber: note)
                        } label: {
                            self.viewModel.tileColors[index].screen
                        }
                        .buttonStyle(
                            XylophoneTileButtonStyle(
                                index: index,
                                tileNumber: self.viewModel.selectedSong.song.scale.count,
                                tileWidth: 100,
                                isTappable: self.viewModel.scale.contains(note)
                            )
                        )
                        .disabled(!self.viewModel.isTappable)
                        .modifier(
                            KeyboardModeModifier(
                                isPartial: self.viewModel.keyboardMode == .partial, isDisabled: !self.viewModel.scale.contains(note)
                            )
                        )
                        .compositingGroup()
                    }
                }
            }
            .blur(radius: self.viewModel.showPlayButton ? 10 : 0)
            .disabled(self.viewModel.showPlayButton)

            if self.viewModel.showPlayButton {
                VStack(spacing: 50) {
                    MelodyPlayerButton(showModal: self.$viewModel.showPlayButton, isMelodyPlaying: self.viewModel.isMelodyPlaying) {
                        self.viewModel.playSong()
                    }

                    if self.viewModel.progress != 1.0 {
                        Button {
                            self.viewModel.showPlayButton = false
                            self.viewModel.stopMelody()
                            self.viewModel.startMelody()
                        } label: {
                            CapsuleColoredButtonLabel(String(l10n.MelodyView.skipButtonLabel.characters), color: .orange)
                        }
                    }
                }
            }
        }
        .onDisappear {
            self.viewModel.stopMelody()
        }
    }

    // MARK: Internal

    struct KeyboardModeModifier: ViewModifier {
        @Environment(\.colorScheme) var colorScheme

        var isPartial: Bool
        var isDisabled: Bool

        func body(content: Content) -> some View {
            if self.isPartial {
                content
                    .disabled(self.isDisabled)
                    .overlay {
                        if self.isDisabled {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(self.colorScheme == .light ? Color.white.opacity(0.9) : Color.black.opacity(0.85))
                        }
                    }
            } else {
                content
            }
        }
    }

    @State var viewModel: NewMelodyViewViewModel

    // MARK: Private

    private let kTilesSpacing: CGFloat = 16
}

#Preview {
    let instrument: MIDIInstrument = .xylophone
    let songs: [MidiRecordingPlayerSong] = [
        MidiRecordingPlayerSong(song: "Under_The_Moonlight"),
    ]
    let coordinator = NewMelodyCoordinator(instrument: instrument, songs: songs)
    let viewModel = NewMelodyViewViewModel(coordinator: coordinator)

    return MelodyXylophoneView(viewModel: viewModel)
}

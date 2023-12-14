// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import ContentKit
import RobotKit
import SwiftUI

// swiftlint:disable nesting
public extension MelodyView {
    struct XylophoneView: View {
        // MARK: Lifecycle

        init(
            instrument: MIDIInstrument, selectedSong: MidiRecording, keyboard: Keyboard, data: ExerciseSharedData? = nil
        ) {
            self._viewModel = StateObject(
                wrappedValue: ViewModel(
                    midiPlayer: MIDIPlayer(instrument: instrument), selectedSong: selectedSong, shared: data
                ))
            self.keyboard = keyboard
            self.scale = selectedSong.scale
        }

        // MARK: Public

        public var body: some View {
            ZStack {
                VStack(spacing: 50) {
                    ContinuousProgressBar(progress: self.viewModel.progress)
                        .animation(.easeOut, value: self.viewModel.progress)
                        .padding(.horizontal)

                    HStack(spacing: self.tilesSpacing) {
                        ForEach(self.scale.enumerated().map { $0 }, id: \.0) { index, note in
                            Button {
                                self.viewModel.onTileTapped(noteNumber: note)
                            } label: {
                                self.viewModel.tileColors[index].screen
                            }
                            .buttonStyle(
                                XylophoneTileButtonStyle(
                                    index: index,
                                    tileNumber: self.scale.count,
                                    tileWidth: 100,
                                    isTappable: self.viewModel.scale.contains(note)
                                )
                            )
                            .disabled(self.viewModel.isNotTappable)
                            .modifier(
                                KeyboardModeModifier(
                                    isPartial: self.keyboard == .partial, isDisabled: !self.viewModel.scale.contains(note)
                                )
                            )
                            .compositingGroup()
                        }
                    }
                }
                .blur(radius: self.viewModel.showModal ? 10 : 0)

                if self.viewModel.showModal {
                    PlayerButton(showModal: self.$viewModel.showModal) {
                        self.viewModel.playMIDIRecording()
                    }
                }
            }
            .onAppear {
                self.viewModel.showModal = true
            }
            .onDisappear {
                self.viewModel.setMIDIRecording(
                    midiRecording: MidiRecording(.none))
                self.viewModel.midiPlayer.stop()
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

        // MARK: Private

        @StateObject private var viewModel: ViewModel

        private var scale: [MIDINoteNumber]
        private let tilesSpacing: CGFloat = 16
        private let keyboard: Keyboard
    }
}

// swiftlint:enable nesting

#Preview {
    MelodyView.XylophoneView(
        instrument: .xylophone, selectedSong: MidiRecording(.aGreenMouse), keyboard: .full
    )
}

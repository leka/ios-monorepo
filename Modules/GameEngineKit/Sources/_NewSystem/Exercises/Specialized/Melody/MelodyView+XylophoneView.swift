// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import ContentKit
import RobotKit
import SwiftUI

// swiftlint:disable nesting
extension MelodyView {

    public struct XylophoneView: View {
        @StateObject private var viewModel: ViewModel
        @Environment(\.colorScheme) var colorScheme

        private var scale: [MIDINoteNumber]
        private let tilesSpacing: CGFloat = 16
        private let keyboard: Keyboard

        init(
            instrument: MIDIInstrument, selectedSong: MidiRecording, keyboard: Keyboard, data: ExerciseSharedData? = nil
        ) {
            self._viewModel = StateObject(
                wrappedValue: ViewModel(
                    midiPlayer: MIDIPlayer(instrument: instrument), selectedSong: selectedSong, shared: data)
            )
            self.keyboard = keyboard
            self.scale = selectedSong.scale
        }

        public var body: some View {
            ZStack {

                VStack(spacing: 50) {
                    ContinuousProgressBar(progress: viewModel.progress)
                        .animation(.easeOut, value: viewModel.progress)
                        .padding(.horizontal)

                    HStack(spacing: tilesSpacing) {
                        ForEach(scale.enumerated().map { $0 }, id: \.0) { index, note in
                            Button {
                                viewModel.onTileTapped(noteNumber: note)
                            } label: {
                                viewModel.tileColors[index].screen
                            }
                            .buttonStyle(
                                XylophoneTileButtonStyle(
                                    index: index,
                                    tileNumber: scale.count,
                                    tileWidth: 100,
                                    isTappable: viewModel.scale.contains(note)
                                )
                            )
                            .disabled(viewModel.isNotTappable)
                            .modifier(
                                KeyboardModeModifier(
                                    colorScheme: colorScheme,
                                    isPartial: keyboard == .partial,
                                    isDisabled: !viewModel.scale.contains(note)
                                )
                            )
                            .compositingGroup()
                        }
                    }
                    .blur(radius: viewModel.showModal ? 10 : 0)
                }

                if viewModel.showModal {
                    PlayMelodyModalView(progress: $viewModel.progress)
                }

            }
            .onAppear {
                viewModel.showModal = true
                viewModel.playMIDIRecording()
            }
            .onDisappear {
                viewModel.setMIDIRecording(
                    midiRecording: MidiRecording(.none))
                viewModel.midiPlayer.stop()
            }
        }

        struct KeyboardModeModifier: ViewModifier {
            let colorScheme: ColorScheme
            var isPartial: Bool
            var isDisabled: Bool

            func body(content: Content) -> some View {
                if isPartial {
                    content
                        .disabled(isDisabled)
                        .overlay {
                            if isDisabled {
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(colorScheme == .light ? Color.white.opacity(0.9) : Color.black.opacity(0.85))
                            }
                        }
                } else {
                    content
                }
            }
        }
    }

}
// swiftlint:enable nesting

#Preview {
    MelodyView.XylophoneView(
        instrument: .xylophone, selectedSong: MidiRecording(.aGreenMouse), keyboard: .full)
}

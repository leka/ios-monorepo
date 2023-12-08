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
        @EnvironmentObject var blurManager: BlurManager
        @Environment(\.colorScheme) var colorScheme

        private var scale: [MIDINoteNumber]
        private let tilesSpacing: CGFloat = 16
        private let keyboard: Keyboard
        private let instructions: MidiRecordingPlayer.Payload.Instructions

        init(
            instrument: MIDIInstrument, selectedSong: MidiRecording, keyboard: Keyboard,
            instructions: MidiRecordingPlayer.Payload.Instructions, data: ExerciseSharedData? = nil
        ) {
            self._viewModel = StateObject(
                wrappedValue: ViewModel(
                    midiPlayer: MIDIPlayer(instrument: instrument), selectedSong: selectedSong, shared: data)
            )
            self.keyboard = keyboard
            self.instructions = instructions
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
                }
                .blur(radius: blurManager.isBlurred ? blurManager.radius : 0)

                if viewModel.showModal {
                    VStack {
                        PlayMelodyModalView(
                            showModal: $viewModel.showModal, viewModel: viewModel,
                            textStartMelody: instructions.textStartMelody,
                            textSkipMelody: instructions.textSkipMelody
                        ) {
                            viewModel.playMIDIRecording()
                        }
                        .background(colorScheme == .light ? Color.white : Color.black)
                        .cornerRadius(10)
                        Spacer()
                    }
                }

            }
            .onAppear {
                viewModel.showModal = true
            }
            .onReceive(viewModel.$showModal) {
                blurManager.isBlurred = $0
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
    let instructions = MidiRecordingPlayer.Payload.Instructions(
        textMusicSelection: "Sélection de la musique",
        textButtonPlay: "Jouer",
        textKeyboardPartial: "Clavier partiel",
        textKeyboardFull: "Clavier entier",
        textStartMelody: "Appuie sur le bouton Play pour écouter et voir Leka jouer de la musique!",
        textSkipMelody: "Passer la chanson"
    )

    return MelodyView.XylophoneView(
        instrument: .xylophone, selectedSong: MidiRecording(.aGreenMouse), keyboard: .full, instructions: instructions)
}

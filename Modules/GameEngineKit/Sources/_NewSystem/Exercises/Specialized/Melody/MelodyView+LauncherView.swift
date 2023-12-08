// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension MelodyView {

    struct LauncherView: View {
        @Binding var selectedSong: MidiRecording
        @Binding var mode: Stage
        @Binding var keyboard: Keyboard
        let songs: [MidiRecording]
        let instructions: MidiRecordingPlayer.Payload.Instructions

        var body: some View {
            VStack(spacing: 70) {
                HStack(spacing: 70) {
                    GameEngineKitAsset.Exercises.Melody.imageIllustration.swiftUIImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing, 50)

                    VStack(spacing: 15) {
                        HStack(spacing: 40) {
                            VStack(spacing: 0) {
                                GameEngineKitAsset.Exercises.Melody.iconKeyboardPartial.swiftUIImage
                                    .resizable()
                                    .scaledToFit()
                                Text(instructions.textKeyboardPartial)
                                    .foregroundStyle(keyboard == .partial ? .black : .gray.opacity(0.4))
                            }

                            Toggle(
                                "",
                                isOn: Binding<Bool>(
                                    get: { self.keyboard == .full },
                                    set: { self.keyboard = $0 ? .full : .partial }
                                )
                            )
                            .toggleStyle(BinaryChoiceToggleStyle())

                            VStack(spacing: 0) {
                                GameEngineKitAsset.Exercises.Melody.iconKeyboardFull.swiftUIImage
                                    .resizable()
                                    .scaledToFit()
                                Text(instructions.textKeyboardFull)
                                    .foregroundStyle(keyboard == .full ? .black : .gray.opacity(0.4))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                        SongSelectorView(
                            songs: songs, selectedMidiRecording: $selectedSong,
                            textMusicSelection: instructions.textMusicSelection
                        )
                        .frame(maxHeight: 260)
                    }
                    .frame(maxWidth: 460, maxHeight: 400)
                }
                .padding(.horizontal, 100)

                Button {
                    mode = .selectionConfirmed
                } label: {
                    ButtonLabel(instructions.textButtonPlay, color: .cyan)
                }
            }
        }
    }
}

#Preview {
    let songs = [
        MidiRecording(.underTheMoonlight),
        MidiRecording(.aGreenMouse),
        MidiRecording(.twinkleTwinkleLittleStar),
        MidiRecording(.londonBridgeIsFallingDown),
        MidiRecording(.ohTheCrocodiles),
        MidiRecording(.happyBirthday),
    ]
    let instructions = MidiRecordingPlayer.Payload.Instructions(
        textMusicSelection: "Sélection de la musique",
        textButtonPlay: "Jouer",
        textKeyboardPartial: "Clavier partiel",
        textKeyboardFull: "Clavier entier",
        textStartMelody: "Appuie sur le bouton Play pour écouter et voir Leka jouer de la musique!",
        textSkipMelody: "Passer la chanson"
    )

    return MelodyView.LauncherView(
        selectedSong: .constant(MidiRecording(.underTheMoonlight)),
        mode: .constant(.waitingForSelection),
        keyboard: .constant(.partial),
        songs: songs,
        instructions: instructions
    )
}

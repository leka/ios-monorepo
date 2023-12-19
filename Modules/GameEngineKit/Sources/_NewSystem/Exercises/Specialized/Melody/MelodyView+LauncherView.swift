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
            VStack(spacing: 100) {
                HStack(spacing: 30) {
                    GameEngineKitAsset.Exercises.Melody.imageIllustration.swiftUIImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing, 50)

                    VStack(spacing: 0) {
                        KeyboardModeView(keyboard: self.$keyboard, instructions: self.instructions)

                        SongSelectorView(
                            songs: self.songs, selectedMidiRecording: self.$selectedSong,
                            textMusicSelection: self.instructions.textMusicSelection
                        )
                    }
                }
                .padding(.horizontal, 100)

                Button {
                    self.mode = .selectionConfirmed
                } label: {
                    ButtonLabel(self.instructions.textButtonPlay, color: .cyan)
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
        textKeyboardFull: "Clavier entier"
    )

    return MelodyView.LauncherView(
        selectedSong: .constant(MidiRecording(.underTheMoonlight)),
        mode: .constant(.waitingForSelection),
        keyboard: .constant(.partial),
        songs: songs,
        instructions: instructions
    )
}

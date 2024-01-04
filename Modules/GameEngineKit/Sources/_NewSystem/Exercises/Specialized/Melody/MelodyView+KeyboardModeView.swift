// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import SwiftUI

extension MelodyView {
    struct KeyboardModeView: View {
        // MARK: Lifecycle

        init(keyboard: Binding<KeyboardType>, instructions: MidiRecordingPlayer.Payload.Instructions) {
            self._keyboard = keyboard
            self.instructions = instructions
        }

        // MARK: Internal

        var body: some View {
            HStack(spacing: 40) {
                VStack(spacing: 0) {
                    GameEngineKitAsset.Exercises.Melody.iconKeyboardPartial.swiftUIImage
                        .resizable()
                        .scaledToFit()
                    Text(self.instructions.textKeyboardPartial)
                        .foregroundStyle(self.keyboard == .partial ? .black : .gray.opacity(0.4))
                }
                .onTapGesture {
                    withAnimation {
                        self.keyboard = .partial
                    }
                }

                VStack(spacing: 0) {
                    GameEngineKitAsset.Exercises.Melody.iconKeyboardFull.swiftUIImage
                        .resizable()
                        .scaledToFit()
                    Text(self.instructions.textKeyboardFull)
                        .foregroundStyle(self.keyboard == .full ? .black : .gray.opacity(0.4))
                }
                .onTapGesture {
                    withAnimation {
                        self.keyboard = .full
                    }
                }
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 40)
        }

        // MARK: Private

        @Binding private var keyboard: KeyboardType
        private let instructions: MidiRecordingPlayer.Payload.Instructions
    }
}

#Preview {
    let songs = [
        MidiRecording(.aGreenMouse),
        MidiRecording(.londonBridgeIsFallingDown),
        MidiRecording(.twinkleTwinkleLittleStar),
        MidiRecording(.underTheMoonlight),
    ]
    let instructions = MidiRecordingPlayer.Payload.Instructions(
        textMusicSelection: "Sélection de la musique",
        textButtonPlay: "Jouer",
        textKeyboardPartial: "Clavier partiel",
        textKeyboardFull: "Clavier entier"
    )

    return MelodyView.KeyboardModeView(
        keyboard: .constant(.partial),
        instructions: instructions
    )
}

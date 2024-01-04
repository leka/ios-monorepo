// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension DanceFreezeView {
    struct LauncherView: View {
        @Binding var mode: Stage
        @Binding var motion: Motion
        @Binding var selectedAudioRecording: AudioRecording
        let songs: [AudioRecording]
        let instructions: DanceFreeze.Payload.Instructions

        var body: some View {
            VStack(spacing: 100) {
                Text(self.instructions.textMainInstructions)
                    .font(.headline)
                    .padding(.top, 30)

                HStack(spacing: 30) {
                    VStack(spacing: 0) {
                        GameEngineKitAsset.Exercises.DanceFreeze.imageIllustration.swiftUIImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }

                    VStack(spacing: 0) {
                        MotionSelectorView(motion: self.$motion, instructions: self.instructions)

                        SongSelectorView(
                            songs: self.songs,
                            selectedAudioRecording: self.$selectedAudioRecording,
                            textMusicSelection: self.instructions.textMusicSelection
                        )
                    }
                }
                .padding(.horizontal, 100)

                HStack(spacing: 70) {
                    Button {
                        self.mode = .manualMode
                    } label: {
                        StageModeButtonStyle(self.instructions.textButtonModeManual, color: .cyan)
                    }

                    Button {
                        self.mode = .automaticMode
                    } label: {
                        StageModeButtonStyle(self.instructions.textButtonModeAuto, color: .mint)
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
}

#Preview {
    let songs = [
        AudioRecording(name: "Giggly Squirrel", file: "Giggly_Squirrel"),
        AudioRecording(name: "Empty Page", file: "Empty_Page"),
        AudioRecording(name: "Early Bird", file: "Early_Bird"),
        AudioRecording(name: "Hands On", file: "Hands_On"),
        AudioRecording(name: "In The Game", file: "In_The_Game"),
        AudioRecording(name: "Little by Little", file: "Little_by_little"),
    ]
    let instructions = DanceFreeze.Payload.Instructions(
        textMainInstructions: "Danse avec Leka au rythme de la musique et fais la statue lorsqu'il s'arrête.",
        textMotionSelection: "Sélection du mouvement",
        textMusicSelection: "Sélection de la musique",
        textButtonRotation: "Rotation",
        textButtonMovement: "Mouvement",
        textButtonModeManual: "Jouer - Mode manuel",
        textButtonModeAuto: "Jouer - Mode auto"
    )

    return DanceFreezeView.LauncherView(
        mode: .constant(.waitingForSelection),
        motion: .constant(.rotation),
        selectedAudioRecording: .constant(AudioRecording(.gigglySquirrel)),
        songs: songs,
        instructions: instructions
    )
}

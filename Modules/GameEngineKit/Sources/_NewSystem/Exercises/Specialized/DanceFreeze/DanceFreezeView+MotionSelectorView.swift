// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import SwiftUI

extension DanceFreezeView {
    struct MotionSelectorView: View {
        // MARK: Lifecycle

        init(motion: Binding<Motion>, instructions: DanceFreeze.Payload.Instructions) {
            self._motion = motion
            self.instructions = instructions
        }

        // MARK: Internal

        var body: some View {
            VStack {
                HStack(spacing: 70) {
                    VStack(spacing: 0) {
                        MotionModeButtonStyle(
                            image: GameEngineKitAsset.Exercises.DanceFreeze.iconMotionModeRotation.swiftUIImage,
                            color: self.motion == .rotation ? .teal : .primary
                        )
                        Text(self.instructions.textButtonRotation)
                    }
                    .foregroundStyle(self.motion == .rotation ? .teal : .primary)
                    .onTapGesture {
                        withAnimation {
                            self.motion = .rotation
                        }
                    }

                    VStack(spacing: 0) {
                        MotionModeButtonStyle(
                            image: GameEngineKitAsset.Exercises.DanceFreeze.iconMotionModeMovement.swiftUIImage,
                            color: self.motion == .movement ? .teal : .primary
                        )
                        Text(self.instructions.textButtonMovement)
                    }
                    .foregroundStyle(self.motion == .movement ? .teal : .primary)
                    .onTapGesture {
                        withAnimation {
                            self.motion = .movement
                        }
                    }
                }
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 40)
        }

        // MARK: Private

        @Binding private var motion: Motion
        private let instructions: DanceFreeze.Payload.Instructions
    }
}

#Preview {
    let instructions = DanceFreeze.Payload.Instructions(
        textMainInstructions: "Danse avec Leka au rythme de la musique et fais la statue lorsqu'il s'arrête.",
        textMotionSelection: "Sélection du mouvement",
        textMusicSelection: "Sélection de la musique",
        textButtonRotation: "Rotation",
        textButtonMovement: "Mouvement",
        textButtonModeManual: "Jouer - Mode manuel",
        textButtonModeAuto: "Jouer - Mode auto"
    )

    return DanceFreezeView.MotionSelectorView(motion: .constant(.rotation), instructions: instructions)
}

// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

extension DanceFreezeView {
    struct MotionSelectorView: View {
        // MARK: Lifecycle

        init(motion: Binding<Motion>) {
            self._motion = motion
        }

        // MARK: Internal

        var body: some View {
            VStack {
                HStack(spacing: 70) {
                    VStack(spacing: 0) {
                        MotionModeButtonStyle(
                            image: ContentKitAsset.GameEngineExercises.DanceFreeze.iconMotionModeRotation.swiftUIImage,
                            color: self.motion == .rotation ? .teal : .primary
                        )
                        Text(l10n.DanceFreezeView.rotationButtonLabel)
                    }
                    .foregroundStyle(self.motion == .rotation ? .teal : .primary)
                    .onTapGesture {
                        withAnimation {
                            self.motion = .rotation
                        }
                    }

                    VStack(spacing: 0) {
                        MotionModeButtonStyle(
                            image: ContentKitAsset.GameEngineExercises.DanceFreeze.iconMotionModeMovement.swiftUIImage,
                            color: self.motion == .movement ? .teal : .primary
                        )
                        Text(l10n.DanceFreezeView.movementButtonLabel)
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
    }
}

#Preview {
    DanceFreezeView.MotionSelectorView(motion: .constant(.rotation))
}

// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - DanceFreezeMotion

public enum DanceFreezeMotion {
    case rotation
    case movement
}

// MARK: - DanceFreezeMotionSelectorView

struct DanceFreezeMotionSelectorView: View {
    // MARK: Lifecycle

    init(motion: Binding<DanceFreezeMotion>) {
        self._motion = motion
    }

    // MARK: Internal

    var body: some View {
        VStack {
            Text(l10n.DanceFreezeView.motionSelectionTitle)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            HStack(spacing: 70) {
                HStack {
                    Image(systemName: self.motion == .rotation ? "checkmark.circle.fill" : "circle")
                        .imageScale(.large)
                        .foregroundColor(
                            self.motion == .rotation
                                ? self.styleManager.accentColor! : .primary
                        )
                    VStack(spacing: 0) {
                        DanceFreezeMotionModeButtonStyle(
                            image: GameEngineKitAsset.Exercises.DanceFreeze.iconMotionModeRotation.swiftUIImage,
                            color: self.motion == .rotation ? self.styleManager.accentColor! : .primary
                        )
                        Text(l10n.DanceFreezeView.rotationButtonLabel)
                    }
                }
                .foregroundStyle(self.motion == .rotation ? self.styleManager.accentColor! : .primary)
                .onTapGesture {
                    withAnimation {
                        self.motion = .rotation
                    }
                }

                HStack {
                    Image(systemName: self.motion == .movement ? "checkmark.circle.fill" : "circle")
                        .imageScale(.large)
                        .foregroundColor(
                            self.motion == .movement
                                ? self.styleManager.accentColor! : .primary
                        )
                    VStack(spacing: 0) {
                        DanceFreezeMotionModeButtonStyle(
                            image: GameEngineKitAsset.Exercises.DanceFreeze.iconMotionModeMovement.swiftUIImage,
                            color: self.motion == .movement ? self.styleManager.accentColor! : .primary
                        )
                        Text(l10n.DanceFreezeView.movementButtonLabel)
                    }
                }
                .foregroundStyle(self.motion == .movement ? self.styleManager.accentColor! : .primary)
                .onTapGesture {
                    withAnimation {
                        self.motion = .movement
                    }
                }
            }
        }
    }

    // MARK: Private

    @Binding private var motion: DanceFreezeMotion
    @ObservedObject private var styleManager: StyleManager = .shared
}

#Preview {
    DanceFreezeMotionSelectorView(motion: .constant(.rotation))
}

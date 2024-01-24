// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

extension MelodyView {
    struct KeyboardModeView: View {
        // MARK: Lifecycle

        init(keyboard: Binding<KeyboardType>) {
            self._keyboard = keyboard
        }

        // MARK: Internal

        var body: some View {
            HStack(spacing: 40) {
                VStack(spacing: 0) {
                    GameEngineKitAsset.Exercises.Melody.iconKeyboardPartial.swiftUIImage
                        .resizable()
                        .scaledToFit()
                    Text(l10n.MelodyView.partialKeyboardLabel)
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
                    Text(l10n.MelodyView.fullKeyboardLabel)
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
    }
}

#Preview {
    let songs = [
        MidiRecording(.aGreenMouse),
        MidiRecording(.londonBridgeIsFallingDown),
        MidiRecording(.twinkleTwinkleLittleStar),
        MidiRecording(.underTheMoonlight),
    ]

    return MelodyView.KeyboardModeView(
        keyboard: .constant(.partial)
    )
}

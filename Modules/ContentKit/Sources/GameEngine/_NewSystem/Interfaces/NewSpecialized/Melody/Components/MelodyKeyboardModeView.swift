// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

struct MelodyKeyboardModeView: View {
    // MARK: Lifecycle

    init(keyboard: Binding<MelodyKeyboardType>) {
        self._keyboard = keyboard
    }

    // MARK: Internal

    var body: some View {
        VStack {
            Text(l10n.MelodyView.keyboardSelectionTitle)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            HStack(spacing: 40) {
                HStack {
                    Image(systemName: self.keyboard == .partial ? "checkmark.circle.fill" : "circle")
                        .imageScale(.large)
                        .foregroundColor(
                            self.keyboard == .partial
                                ? self.styleManager.accentColor! : .primary
                        )
                    VStack(spacing: 0) {
                        ContentKitAsset.Exercises.Melody.iconKeyboardPartial.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                        Text(l10n.MelodyView.partialKeyboardLabel)
                            .foregroundStyle(self.keyboard == .partial ? self.styleManager.accentColor! : .primary)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        self.keyboard = .partial
                    }
                }

                HStack {
                    Image(systemName: self.keyboard == .full ? "checkmark.circle.fill" : "circle")
                        .imageScale(.large)
                        .foregroundColor(
                            self.keyboard == .full
                                ? self.styleManager.accentColor! : .primary
                        )
                    VStack(spacing: 0) {
                        ContentKitAsset.Exercises.Melody.iconKeyboardFull.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130)
                        Text(l10n.MelodyView.fullKeyboardLabel)
                            .foregroundStyle(self.keyboard == .full ? self.styleManager.accentColor! : .primary)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        self.keyboard = .full
                    }
                }
            }
        }
    }

    // MARK: Private

    @Binding private var keyboard: MelodyKeyboardType

    private var styleManager: StyleManager = .shared
}

#Preview {
    MelodyKeyboardModeView(
        keyboard: .constant(.partial)
    )
}

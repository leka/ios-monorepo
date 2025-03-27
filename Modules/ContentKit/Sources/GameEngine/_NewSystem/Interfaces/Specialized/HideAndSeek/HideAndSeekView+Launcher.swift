// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

extension HideAndSeekView {
    struct Launcher: View {
        @Binding var stage: HideAndSeekStage

        var body: some View {
            VStack {
                Text(l10n.HideAndSeekView.Launcher.instructions)
                    .font(.headline)
                ContentKitAsset.Exercises.HideAndSeek.imageIllustration.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500, height: 500)

                Button {
                    self.stage = .hidden
                } label: {
                    ButtonLabel(String(l10n.HideAndSeekView.Launcher.okButtonLabel.characters).uppercased(), color: .cyan)
                }
            }
            .scaledToFill()
        }
    }
}

#Preview {
    HideAndSeekView.Launcher(stage: .constant(.toHide))
}

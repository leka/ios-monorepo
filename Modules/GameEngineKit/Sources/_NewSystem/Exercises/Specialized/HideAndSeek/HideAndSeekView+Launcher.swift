// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

extension HideAndSeekView {
    struct Launcher: View {
        @Binding var stage: HideAndSeekStage
        let textMainInstructions: String
        let textButtonOk: String

        var body: some View {
            VStack {
                Text(self.textMainInstructions)
                GameEngineKitAsset.Exercises.HideAndSeek.imageIllustration.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500, height: 500)

                Button {
                    self.stage = .hidden
                } label: {
                    ButtonLabel(self.textButtonOk, color: .cyan)
                }
            }
            .scaledToFill()
        }
    }
}

#Preview {
    HideAndSeekView.Launcher(stage: .constant(.toHide), textMainInstructions: "Cache Leka", textButtonOk: "OK")
}

// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct HideAndSeekModeButtonLabel: View {
    let text: String
    let color: Color

    init(_ text: String, color: Color) {
        self.text = text
        self.color = color
    }

    var body: some View {
        Text(text)
            .font(.title2)
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .frame(width: 400, height: 50)
            .scaledToFit()
            .background(Capsule().fill(color).shadow(radius: 3))
    }
}

struct HideAndSeekLauncher: View {
    @Binding var stage: HideAndSeekStage

    var body: some View {
        VStack {
            Text("Appuyer sur **OK** lorsque Leka est caché")
            Image(GameEngineKitAsset.Assets.hideAndSeek.name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 500, height: 500)

            Button {
                stage = .hidden
            } label: {
                HideAndSeekModeButtonLabel("OK", color: .cyan)
            }
        }
        .scaledToFill()
        .alertWhenRobotIsNeeded()
    }
}

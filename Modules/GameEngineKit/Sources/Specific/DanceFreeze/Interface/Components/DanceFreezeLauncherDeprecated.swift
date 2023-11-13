// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct DanceFreezeModeButtonLabelDeprecated: View {
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

struct DanceFreezeLauncherDeprecated: View {
    @Binding var mode: DanceFreezeStageDeprecated

    var body: some View {
        VStack(spacing: 100) {
            HStack(spacing: 0) {
                GameEngineKitAsset.Assets.danceFreeze.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.trailing, 50)

                SongSelectorDeprecated()
                    .frame(maxHeight: 250)

            }
            .padding(.horizontal, 100)

            HStack(spacing: 20) {
                Button {
                    mode = .manualMode
                } label: {
                    DanceFreezeModeButtonLabelDeprecated("Jouer - mode manuel", color: .cyan)
                }

                Button {
                    mode = .automaticMode
                } label: {
                    DanceFreezeModeButtonLabelDeprecated("Jouer - mode auto", color: .mint)
                }
            }
        }
    }
}

struct DanceFreezeLauncherDeprecated_Previews:
    PreviewProvider
{
    static var previews: some View {
        DanceFreezeLauncherDeprecated(mode: .constant(.waitingForSelection))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

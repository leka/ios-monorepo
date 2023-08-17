// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum Stimulation: String, CaseIterable {
    case light
    case motion

    public func icon() -> Image {
        switch self {
            case .light:
                return Image(GameEngineKitAsset.Assets.pictogramLekaLight.name)
            case .motion:
                return Image(GameEngineKitAsset.Assets.pictogramLekaMotion.name)
        }
    }
}

struct HideAndSeekPlayer: View {
    @Binding var stage: HideAndSeekStage

    var body: some View {
        ZStack {
            HiddenView()
                .padding(.horizontal, 30)

            HStack {
                Spacer()
                VStack(spacing: 70) {
                    stimulationButton(Stimulation.light)
                    stimulationButton(Stimulation.motion)
                }
                .padding(.trailing, 60)
            }

            VStack {
                Spacer()

                Button {
                    stage = .toHide
                    // Play reinforcer
                } label: {
                    HideAndSeekModeButtonLabel("Trouvé !", color: .cyan)
                }
                .padding(.vertical, 30)
            }
        }
    }

    func stimulationButton(_ stimulation: Stimulation) -> some View {
        Button {
            switch stimulation {
                case .light:
                    // TODO(@ladislas): Run a LED animation
                    print("Trigger light")
                case .motion:
                    // TODO(@ladislas): Run a motor animation
                    print("Trigger motion")
            }
        } label: {
            stimulation.icon()
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 108, maxHeight: 108)
                .padding(20)
        }

        .background(
            Circle()
                .fill(.white)
        )

    }
}

struct HideAndSeekPlayer_Previews:
    PreviewProvider
{
    static var previews: some View {
        HideAndSeekPlayer(stage: .constant(.hidden))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

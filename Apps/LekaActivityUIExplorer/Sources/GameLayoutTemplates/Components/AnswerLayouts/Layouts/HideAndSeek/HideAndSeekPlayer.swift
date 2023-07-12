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
                return Image("pictogram_leka_light")
            case .motion:
                return Image("pictogram_leka_motion")
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
                    print("Trigger light")
                case .motion:
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
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
        )
    }
}

struct HideAndSeekPlayer_Previews: PreviewProvider {
    static var previews: some View {
        HideAndSeekPlayer(stage: .constant(.hidden))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

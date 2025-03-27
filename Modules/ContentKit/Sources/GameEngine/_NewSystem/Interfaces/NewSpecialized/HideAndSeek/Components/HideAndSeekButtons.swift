// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - Stimulation

enum Stimulation: String, CaseIterable {
    case light
    case motion

    // MARK: Public

    public func icon() -> Image {
        switch self {
            case .light:
                ContentKitAsset.Exercises.HideAndSeek.iconStimulationLight.swiftUIImage
            case .motion:
                ContentKitAsset.Exercises.HideAndSeek.iconStimulationMotion.swiftUIImage
        }
    }
}

// MARK: - HideAndSeekStimulationButton

struct HideAndSeekStimulationButton: View {
    let stimulation: Stimulation
    let action: () -> Void

    var body: some View {
        Button {
            self.action()
        } label: {
            self.stimulation.icon()
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 108, maxHeight: 108)
                .padding(20)
                .background(
                    Circle()
                        .fill(.white)
                )
        }
    }
}

#Preview {
    HStack(spacing: 100) {
        HideAndSeekStimulationButton(stimulation: .light, action: { print("Lights") })

        HideAndSeekStimulationButton(stimulation: .motion, action: { print("Motion") })
    }
}

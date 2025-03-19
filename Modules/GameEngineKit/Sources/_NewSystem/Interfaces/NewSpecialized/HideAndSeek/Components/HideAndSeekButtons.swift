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
                GameEngineKitAsset.Exercises.HideAndSeek.iconStimulationLight.swiftUIImage
            case .motion:
                GameEngineKitAsset.Exercises.HideAndSeek.iconStimulationMotion.swiftUIImage
        }
    }
}

// MARK: - HideAndSeekButtonLabel

struct HideAndSeekButtonLabel: View {
    // MARK: Lifecycle

    init(_ text: String, color: Color) {
        self.text = text
        self.color = color
    }

    // MARK: Internal

    let text: String
    let color: Color

    var body: some View {
        Text(self.text)
            .font(.body)
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .frame(width: 400, height: 50)
            .scaledToFit()
            .background(Capsule().fill(self.color).shadow(radius: 3))
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
        HideAndSeekButtonLabel("Terminé", color: .cyan)

        HideAndSeekStimulationButton(stimulation: .light, action: { print("Lights") })

        HideAndSeekStimulationButton(stimulation: .motion, action: { print("Motion") })
    }
}

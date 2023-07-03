// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct DanceFreezeModeButtonLabel: View {
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

struct DanceFreezeSelector: View {
    @Binding var mode: DanceFreezeStage

    var body: some View {
        VStack {
            Image("danceFreeze")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400, height: 400)

            HStack(spacing: 70) {
                Button {
                    mode = .manualMode
                } label: {
                    DanceFreezeModeButtonLabel("Jouer manuellement", color: .cyan)
                }

                Button {
                    mode = .automaticMode
                } label: {
                    DanceFreezeModeButtonLabel("Jouer automatiquement", color: .mint)
                }
            }
        }
    }
}

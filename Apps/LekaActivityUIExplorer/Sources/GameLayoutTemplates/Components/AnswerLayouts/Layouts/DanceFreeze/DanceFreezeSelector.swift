// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ModeSelectorModifier: ViewModifier {
    var color: Color

    func body(content: Content) -> some View {
        content
            .font(.title2)
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .frame(width: 400, height: 50)
            .scaledToFit()
            .background(Capsule().fill(color).shadow(radius: 3))
    }
}

extension View {
    func modeSelectorButtonStyle(_ color: Color) -> some View {
        modifier(ModeSelectorModifier(color: color))
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
                    Text("Jouer manuellement")
                        .modeSelectorButtonStyle(.cyan)
                }

                Button {
                    mode = .automaticMode
                } label: {
                    Text("Jouer automatiquement")
                        .modeSelectorButtonStyle(.mint)
                }
            }
        }
    }
}

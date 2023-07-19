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
        VStack(spacing: 100) {
            HStack(spacing: 0) {
                Image("danceFreeze")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.trailing, 50)

                SongSelector()
                    .frame(maxHeight: 250)

            }
            .padding(.horizontal, 100)

            HStack(spacing: 20) {
                Button {
                    mode = .manualMode
                } label: {
                    DanceFreezeModeButtonLabel("Jouer - mode manuel", color: .cyan)
                }

                Button {
                    mode = .automaticMode
                } label: {
                    DanceFreezeModeButtonLabel("Jouer - mode auto", color: .mint)
                }
            }
        }
    }
}

struct DanceFreezeSelector_Previews: PreviewProvider {
    static var previews: some View {
        DanceFreezeSelector(mode: .constant(.waitingForSelection))
            .environmentObject(GameLayoutTemplatesDefaults())
            .previewDevice(PreviewDevice(rawValue: "iPad (9th generation)"))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

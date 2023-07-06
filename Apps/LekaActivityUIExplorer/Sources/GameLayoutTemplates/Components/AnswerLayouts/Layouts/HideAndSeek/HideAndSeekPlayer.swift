// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct HideAndSeekPlayer: View {
    @Binding var stage: HideAndSeekStage

    var body: some View {
        VStack {
            HStack {
                Spacer()

                HiddenView()

                VStack(spacing: 30) {
                    ForEach(Reinforcer.allCases, id: \.self) { reinforcer in
                        reinforcerButton(reinforcer.icon())
                    }
                }
                .padding(20)

            }

            Button {
                stage = .toHide
            } label: {
                HideAndSeekModeButtonLabel("Trouvé !", color: .cyan)
            }
        }
        .padding(10)
    }

    func reinforcerButton(_ reinforcer: Image) -> some View {
        Button {
            // Trigger Reinforcer
        } label: {
            reinforcer
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 108, maxHeight: 108)
                .padding(10)
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
    }
}

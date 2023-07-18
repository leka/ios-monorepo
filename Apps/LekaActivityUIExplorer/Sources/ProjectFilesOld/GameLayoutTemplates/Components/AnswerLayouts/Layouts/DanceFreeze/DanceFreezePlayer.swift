// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct DanceFreezePlayer: View {
    @EnvironmentObject var gameEngine: GameEngine

    @State var isAuto: Bool
    @State private var isDancing: Bool = true

    var body: some View {
        Button {
            withAnimation {
                isDancing.toggle()
            }
        } label: {
            if isDancing {
                DanceView()
                    .transition(.scale)
                    .onAppear {
                        gameEngine.audioPlayer.play()
                    }
                    .onDisappear {
                        gameEngine.audioPlayer.pause()
                    }
            } else {
                FreezeView()
                    .transition(.scale)
            }
        }
        .disabled(isAuto)
        .onAppear {
            if isAuto {
                randomSwitch()
            }
        }
    }

    private func randomSwitch() {
        let rand = Double.random(in: 2..<10)

        DispatchQueue.main.asyncAfter(deadline: .now() + rand) {
            isDancing.toggle()
        }
    }
}

struct DanceFreezePlayer_Previews: PreviewProvider {
    static var previews: some View {
        DanceFreezePlayer(isAuto: false)
            .environmentObject(GameEngine())
    }
}

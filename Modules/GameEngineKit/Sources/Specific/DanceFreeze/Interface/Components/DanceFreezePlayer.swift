// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct DanceFreezePlayer: View {
    @EnvironmentObject var viewModel: DanceFreezeViewModel

    @State var isAuto: Bool
    @State private var isDancing: Bool = true

    public init(isAuto: Bool) {
        self.isAuto = isAuto
    }

    var body: some View {
        VStack {
            ContinuousProgressBar(progress: viewModel.progress)

            Button {
                withAnimation {
                    isDancing.toggle()
                }
                viewModel.onDanceFreezeToggle()
            } label: {
                if isDancing {
                    DanceView()
                        .transition(.scale)
                } else {
                    FreezeView()
                        .transition(.scale)
                }
            }
            .disabled(isAuto)
            .onAppear {
                viewModel.onDanceFreezeToggle()
                if isAuto {
                    randomSwitch()
                }
            }
        }

    }

    private func randomSwitch() {
        let rand = Double.random(in: 2..<10)

        DispatchQueue.main.asyncAfter(deadline: .now() + rand) {
            isDancing.toggle()
            viewModel.onDanceFreezeToggle()
        }
    }
}

struct DanceFreezePlayer_Previews:
    PreviewProvider
{
    static var previews: some View {
        DanceFreezePlayer(isAuto: true)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct DanceFreezePlayerDeprecated: View {
    @EnvironmentObject var viewModel: DanceFreezeViewModelDeprecated

    let isAuto: Bool

    public init(isAuto: Bool) {
        self.isAuto = isAuto
    }

    var body: some View {
        VStack {
            ContinuousProgressBar(progress: viewModel.progress)
                .padding(20)

            Button {
                viewModel.onDanceFreezeToggle()
            } label: {
                if viewModel.isDancing {
                    DanceViewDeprecated()
                } else {
                    FreezeViewDeprecated()
                }
            }
            .disabled(isAuto)
            .onAppear {
                viewModel.onDanceFreezeToggle()
                if isAuto {
                    randomSwitch()
                }
            }
            .onDisappear {
                viewModel.state = .finished
            }
        }

    }

    func randomSwitch() {
        if viewModel.progress < 1.0 && viewModel.state != .finished {
            let rand = Double.random(in: 2..<10)

            DispatchQueue.main.asyncAfter(deadline: .now() + rand) {
                viewModel.onDanceFreezeToggle()
                randomSwitch()
            }
        }
    }
}

struct DanceFreezePlayerDeprecated_Previews:
    PreviewProvider
{
    static var previews: some View {
        DanceFreezePlayerDeprecated(isAuto: true)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

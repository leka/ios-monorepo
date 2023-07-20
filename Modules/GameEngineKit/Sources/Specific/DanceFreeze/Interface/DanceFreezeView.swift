// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum DanceFreezeStage {
    case waitingForSelection
    case automaticMode
    case manualMode
}

public struct DanceFreezeView: View {
    @State private var mode = DanceFreezeStage.waitingForSelection
    @ObservedObject private var viewModel: DanceFreezeViewModel

    public init(gameplay: GameplayPlayMusic) {
        self.viewModel = DanceFreezeViewModel(gameplay: gameplay)
    }

    public var body: some View {
        NavigationStack {
            switch mode {
                case .waitingForSelection:
                    DanceFreezeLauncher(mode: $mode)
                        .alertWhenRobotIsNeeded()
                case .automaticMode:
                    ContinuousProgressBar(progress: viewModel.progress)
                    DanceFreezePlayer(isAuto: true)
                        .onDisappear {
                            viewModel.setSong(song: SongModel(name: "", file: ""))
                        }
                case .manualMode:
                    ContinuousProgressBar(progress: viewModel.progress)
                    DanceFreezePlayer(isAuto: false)
                        .onDisappear {
                            viewModel.setSong(song: SongModel(name: "", file: ""))
                        }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(viewModel)
    }
}

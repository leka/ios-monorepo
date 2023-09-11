// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

enum DanceFreezeStage {
    case waitingForSelection
    case automaticMode
    case manualMode
}

public struct DanceFreezeView: View {
    @State private var mode = DanceFreezeStage.waitingForSelection
    @ObservedObject private var viewModel: DanceFreezeViewModel

    public init(gameplay: DanceFreezeGameplay) {
        self.viewModel = DanceFreezeViewModel(gameplay: gameplay)
    }

    public var body: some View {
        NavigationStack {
            switch mode {
                case .waitingForSelection:
                    DanceFreezeLauncher(mode: $mode)
                case .automaticMode:
                    DanceFreezePlayer(isAuto: true)
                        .onDisappear {
                            viewModel.setAudioRecording(audioRecording: AudioRecordingModel(name: "", file: ""))
                        }
                case .manualMode:
                    DanceFreezePlayer(isAuto: false)
                        .onDisappear {
                            viewModel.setAudioRecording(audioRecording: AudioRecordingModel(name: "", file: ""))
                        }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(viewModel)
    }
}

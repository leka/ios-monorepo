// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

enum DanceFreezeStageDeprecated {
    case waitingForSelection
    case automaticMode
    case manualMode
}

public struct DanceFreezeViewDeprecated: View {
    @State private var mode = DanceFreezeStageDeprecated.waitingForSelection
    @ObservedObject private var viewModel: DanceFreezeViewModelDeprecated

    public init(gameplay: DanceFreezeGameplayDeprecated) {
        self.viewModel = DanceFreezeViewModelDeprecated(gameplay: gameplay)
    }

    public var body: some View {
        NavigationStack {
            switch mode {
                case .waitingForSelection:
                    DanceFreezeLauncherDeprecated(mode: $mode)
                case .automaticMode:
                    DanceFreezePlayerDeprecated(isAuto: true)
                        .onDisappear {
                            viewModel.setAudioRecording(audioRecording: AudioRecordingModelDeprecated(name: "", file: ""))
                        }
                case .manualMode:
                    DanceFreezePlayerDeprecated(isAuto: false)
                        .onDisappear {
                            viewModel.setAudioRecording(audioRecording: AudioRecordingModelDeprecated(name: "", file: ""))
                        }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(viewModel)
    }
}

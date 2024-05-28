// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import SwiftUI

extension DanceFreezeView {
    struct PlayerView: View {
        // MARK: Lifecycle

        public init(selectedAudioRecording: DanceFreeze.Song, isAuto: Bool, motion: Motion, data: ExerciseSharedData? = nil) {
            self._viewModel = StateObject(wrappedValue: ViewModel(selectedAudioRecording: selectedAudioRecording, motion: motion, shared: data))
            self.isAuto = isAuto
            self.motion = motion
        }

        // MARK: Internal

        let isAuto: Bool
        let motion: Motion

        var body: some View {
            VStack {
                ContinuousProgressBar(progress: self.viewModel.progress)
                    .padding(20)

                Button {
                    self.viewModel.onDanceFreezeToggle()
                } label: {
                    if self.viewModel.isDancing {
                        DanceView()
                    } else {
                        FreezeView()
                    }
                }
                .disabled(self.isAuto)
            }
            .onAppear {
                self.viewModel.onDanceFreezeToggle()
                if self.isAuto {
                    self.randomSwitch()
                }
            }
            .onDisappear {
                self.viewModel.completeDanceFreeze()
                guard self.viewModel.didFinishPlaying else {
                    return
                }
                self.saveActivityCompletion()
            }
            .onChange(of: self.viewModel.didFinishPlaying) { finished in
                guard finished else {
                    return
                }
                self.saveActivityCompletion()
            }
        }

        func randomSwitch() {
            if case .completed = self.viewModel.exercicesSharedData.state { return }
            if self.viewModel.progress < 1.0 {
                let rand = Double.random(in: 2..<10)

                DispatchQueue.main.asyncAfter(deadline: .now() + rand) {
                    if case .completed = self.viewModel.exercicesSharedData.state { return }
                    self.viewModel.onDanceFreezeToggle()
                    self.randomSwitch()
                }
            }
        }

        // MARK: Private

        @StateObject private var viewModel: ViewModel
        @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()
        @StateObject private var carereceiverManagerViewModel = CarereceiverManagerViewModel()

        private func saveActivityCompletion() {
            let completionDataString = ActivityCompletionData.encodeCompletionData(from: self.viewModel.completedExerciseData)
            let activityCompletionData = ActivityCompletionData(
                caregiverID: self.caregiverManagerViewModel.currentCaregiver?.id ?? "No caregiver found",
                carereceiverIDs: self.carereceiverManagerViewModel.currentCarereceivers.compactMap(\.id),
                startTimestamp: self.viewModel.completedExerciseData.first?.first?.startTimestamp,
                endTimestamp: self.viewModel.completedExerciseData.last?.last?.endTimestamp,
                completionData: completionDataString
            )
            self.viewModel.saveActivityCompletionData(data: activityCompletionData)
        }
    }
}

#Preview {
    DanceFreezeView.PlayerView(selectedAudioRecording: DanceFreeze.Song(song: "Early_Bird"), isAuto: true, motion: .movement)
}

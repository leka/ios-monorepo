// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import ContentKit
import RobotKit
import SwiftUI

extension DanceFreezeView {
    class ViewModel: ObservableObject {
        // MARK: Lifecycle

        init(selectedAudioRecording: DanceFreeze.Song, motion: Motion, shared: ExerciseSharedData? = nil) {
            self.audioPlayer = AudioPlayer(audioRecording: selectedAudioRecording.audio)
            self.audioPlayer.setAudioPlayer(audioRecording: selectedAudioRecording.audio)
            self.robotManager = RobotManager()
            self.motionMode = motion

            self.exercicesSharedData = shared ?? ExerciseSharedData()
            self.exercicesSharedData.state = .playing

            self.startTimestamp = Date()
            self.chosenSong = selectedAudioRecording.audio

            self.subscribeToAudioPlayerProgress()
        }

        // MARK: Public

        @Published public var progress: CGFloat = 0.0
        @Published public var isDancing: Bool = false
        @Published public var didFinishPlaying: Bool = false

        public func onDanceFreezeToggle() {
            guard !self.audioPlayer.didFinishPlaying else {
                self.completeDanceFreeze()
                return
            }

            if self.audioPlayer.isPlaying {
                self.audioPlayer.pause()
                self.isDancing = false
                self.robotManager.freeze()
            } else {
                self.audioPlayer.play()
                self.isDancing = true
                self.robotDance()
            }
        }

        // MARK: Internal

        @ObservedObject var exercicesSharedData: ExerciseSharedData
        var completedExerciseData: [[ExerciseCompletionData]] = []

        func completeDanceFreeze() {
            self.isDancing = false
            self.robotManager.stopRobot()
            self.audioPlayer.stop()
            self.didFinishPlaying = true

            let completionPayload = ExerciseCompletionData.DanceFreezePayload(
                chosenSong: self.chosenSong
            ).encodeToString()
            let completionData = ExerciseCompletionData(
                startTimestamp: self.startTimestamp,
                endTimestamp: Date(),
                payload: completionPayload
            )
            self.exercicesSharedData.state = .completed(level: .nonApplicable, data: completionData)
            self.completedExerciseData = [[completionData]]
        }

        func saveActivityCompletionData(data: ActivityCompletionData) {
            self.activityCompletionDataManager.saveActivityCompletionData(data: data)
                .sink(receiveCompletion: { completion in
                    switch completion {
                        case .finished:
                            print("Activity Completion Data saved successfully.")
                        case let .failure(error):
                            print("Saving Activity Completion Data failed with error: \(error)")
                    }
                }, receiveValue: { _ in
                    // Nothing to do
                })
                .store(in: &self.cancellables)
        }

        // MARK: Private

        private var robotManager: RobotManager
        private var audioPlayer: AudioPlayer
        private var motionMode: Motion = .rotation
        private var cancellables: Set<AnyCancellable> = []
        private let activityCompletionDataManager: ActivityCompletionDataManager = .shared
        private var startTimestamp: Date?
        private var chosenSong: String = ""

        private func subscribeToAudioPlayerProgress() {
            self.audioPlayer.$progress
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    guard let self else { return }
                    self.progress = $0
                    if self.progress == 1 {
                        self.completeDanceFreeze()
                    }
                }
                .store(in: &self.cancellables)
        }

        private func robotDance() {
            switch self.motionMode {
                case .rotation:
                    self.robotRotation()
                case .movement:
                    self.robotMovement()
            }

            self.robotLightFrenzy()
        }

        private func robotLightFrenzy() {
            guard self.isDancing, !self.exercicesSharedData.isCompleted else { return }

            self.robotManager.shineRandomly()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.robotLightFrenzy()
            }
        }

        private func robotRotation() {
            guard self.isDancing, !self.exercicesSharedData.isCompleted else { return }

            let duration = self.robotManager.rotationDance()

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.robotRotation()
            }
        }

        private func robotMovement() {
            guard self.isDancing, !self.exercicesSharedData.isCompleted else { return }

            let duration = self.robotManager.movementDance()

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.robotMovement()
            }
        }
    }
}

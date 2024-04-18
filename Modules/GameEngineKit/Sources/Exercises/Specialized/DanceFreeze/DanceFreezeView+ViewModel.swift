// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import RobotKit
import SwiftUI

extension DanceFreezeView {
    class ViewModel: ObservableObject {
        // MARK: Lifecycle

        init(selectedAudioRecording: AudioRecording, motion: Motion, shared: ExerciseSharedData? = nil) {
            self.audioPlayer = AudioPlayer(audioRecording: selectedAudioRecording)
            self.audioPlayer.setAudioPlayer(audioRecording: selectedAudioRecording)
            self.robotManager = RobotManager()
            self.motionMode = motion

            self.exercicesSharedData = shared ?? ExerciseSharedData()
            self.exercicesSharedData.state = .playing

            self.subscribeToAudioPlayerProgress()
        }

        // MARK: Public

        @Published public var progress: CGFloat = 0.0
        @Published public var isDancing: Bool = false

        public func onDanceFreezeToggle() {
            if self.progress == 1.0 {
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
        var robotManager: RobotManager
        var audioPlayer: AudioPlayer
        var motionMode: Motion = .rotation
        var cancellables: Set<AnyCancellable> = []

        func completeDanceFreeze() {
            self.robotManager.stopRobot()
            self.audioPlayer.stop()
            self.exercicesSharedData.state = .completed(level: .nonApplicable)
        }

        // MARK: Private

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
            if case .completed = self.exercicesSharedData.state, !self.isDancing { return }

            self.robotManager.shineRandomly()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.robotLightFrenzy()
            }
        }

        private func robotRotation() {
            if case .completed = self.exercicesSharedData.state, !self.isDancing { return }

            let duration = self.robotManager.rotationDance()

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.robotRotation()
            }
        }

        private func robotMovement() {
            if case .completed = self.exercicesSharedData.state, !self.isDancing { return }

            let duration = self.robotManager.movementDance()

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.robotMovement()
            }
        }
    }
}

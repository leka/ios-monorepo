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

        init(selectedAudioRecording: DanceFreeze.Song, motion: Motion, shared: ExerciseSharedData? = nil) {
            self.audioData = .file(name: selectedAudioRecording.audio)
            self.robotManager = RobotManager()
            self.motionMode = motion

            self.exercicesSharedData = shared ?? ExerciseSharedData()
            self.exercicesSharedData.state = .playing()

            self.subscribeToAudioManagerProgress()
        }

        // MARK: Public

        @Published public var progress: CGFloat = 0.0
        @Published public var isDancing: Bool = false

        public func onDanceFreezeToggle() {
            guard self.progress < 1.0 else {
                self.completeDanceFreeze()
                return
            }

            if case .playing = self.audioManager.state.value {
                self.audioManager.pause()
                self.isDancing = false
                self.robotManager.freeze()
            } else {
                self.audioManager.play(self.audioData)
                self.isDancing = true
                self.robotDance()
            }
        }

        // MARK: Internal

        @ObservedObject var exercicesSharedData: ExerciseSharedData

        func completeDanceFreeze() {
            self.isDancing = false
            self.exercicesSharedData.state = .completed(level: .nonApplicable)
            self.robotManager.stopRobot()
            self.audioManager.stop()
        }

        // MARK: Private

        private var robotManager: RobotManager
        private var audioManager: AudioManager = .shared
        private let audioData: AudioManager.AudioType
        private var motionMode: Motion = .rotation
        private var cancellables: Set<AnyCancellable> = []

        private func subscribeToAudioManagerProgress() {
            self.audioManager.progress
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    guard let self else { return }
                    self.progress = $0.percentage
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

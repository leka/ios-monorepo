// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import RobotKit
import SwiftUI

extension DanceFreeze {
    class MainViewViewModel: ObservableObject {
        // MARK: Lifecycle

        init(songs: [AudioRecording], shuffle _: Bool = false, shared: ExerciseSharedData? = nil) {
            self.songs = songs
            self.audioPlayer = AudioPlayer(audioRecording: songs.first!)
            self.robotManager = RobotManager()

            self.exercicesSharedData = shared ?? ExerciseSharedData()
            self.exercicesSharedData.state = .playing

            self.subscribeToAudioPlayerProgress()
        }

        // MARK: Public

        @Published public var progress: CGFloat = 0.0
        @Published public var isDancing: Bool = false

        public func onDanceFreezeToggle() {
            if self.progress == 1.0 {
                self.exercicesSharedData.state = .completed
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

        public func setAudioRecording(audioRecording: AudioRecording) {
            self.audioPlayer.setAudioPlayer(audioRecording: audioRecording)
        }

        public func setMotionMode(motion: Motion) {
            self.motionMode = motion
        }

        // MARK: Internal

        @ObservedObject var exercicesSharedData: ExerciseSharedData
        var robotManager: RobotManager
        var audioPlayer: AudioPlayer
        let songs: [AudioRecording]
        var motionMode: Motion = .rotation
        var cancellables: Set<AnyCancellable> = []

        func completeDanceFreeze() {
            self.robotManager.stopRobot()
            self.exercicesSharedData.state = .completed
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
            guard self.exercicesSharedData.state != .completed, self.isDancing else { return }

            self.robotManager.shineRandomly()

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.2)
            {
                self.robotLightFrenzy()
            }
        }

        private func robotRotation() {
            guard self.exercicesSharedData.state != .completed, self.isDancing else { return }

            let duration = self.robotManager.rotationDance()

            DispatchQueue.main.asyncAfter(
                deadline: .now() + duration)
            {
                self.robotRotation()
            }
        }

        private func robotMovement() {
            guard self.exercicesSharedData.state != .completed, self.isDancing else { return }

            let duration = self.robotManager.movementDance()

            DispatchQueue.main.asyncAfter(
                deadline: .now() + duration)
            {
                self.robotMovement()
            }
        }
    }
}

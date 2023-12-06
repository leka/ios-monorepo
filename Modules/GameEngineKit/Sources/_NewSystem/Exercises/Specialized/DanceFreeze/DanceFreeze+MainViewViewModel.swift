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

        init(songs: [AudioRecording], shuffle: Bool = false, shared: ExerciseSharedData? = nil) {
            self.songs = songs
            self.audioPlayer = AudioPlayer(audioRecording: songs.first!)
            self.robotManager = RobotManager()

            self.exercicesSharedData = shared ?? ExerciseSharedData()
            exercicesSharedData.state = .playing

            subscribeToAudioPlayerProgress()
        }

        // MARK: Public

        @Published public var progress: CGFloat = 0.0
        @Published public var isDancing: Bool = false

        public func onDanceFreezeToggle() {
            if progress == 1.0 {
                exercicesSharedData.state = .completed
                return
            }
            if audioPlayer.isPlaying {
                audioPlayer.pause()
                isDancing = false
                robotManager.freeze()
            } else {
                audioPlayer.play()
                isDancing = true
                robotDance()
            }
        }

        public func setAudioRecording(audioRecording: AudioRecording) {
            audioPlayer.setAudioPlayer(audioRecording: audioRecording)
        }

        public func setMotionMode(motion: Motion) {
            motionMode = motion
        }

        // MARK: Internal

        @ObservedObject var exercicesSharedData: ExerciseSharedData
        var robotManager: RobotManager
        var audioPlayer: AudioPlayer
        let songs: [AudioRecording]
        var motionMode: Motion = .rotation
        var cancellables: Set<AnyCancellable> = []

        func completeDanceFreeze() {
            robotManager.stopRobot()
            exercicesSharedData.state = .completed
        }

        // MARK: Private

        private func subscribeToAudioPlayerProgress() {
            audioPlayer.$progress
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    guard let self else { return }
                    progress = $0
                    if progress == 1 {
                        completeDanceFreeze()
                    }
                }
                .store(in: &cancellables)
        }

        private func robotDance() {
            switch motionMode {
                case .rotation:
                    robotRotation()
                case .movement:
                    robotMovement()
            }
            robotLightFrenzy()
        }

        private func robotLightFrenzy() {
            guard exercicesSharedData.state != .completed, isDancing else { return }

            robotManager.shineRandomly()

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.2,
                execute: {
                    self.robotLightFrenzy()
                })
        }

        private func robotRotation() {
            guard exercicesSharedData.state != .completed, isDancing else { return }

            let duration = robotManager.rotationDance()

            DispatchQueue.main.asyncAfter(
                deadline: .now() + duration,
                execute: {
                    self.robotRotation()
                })
        }

        private func robotMovement() {
            guard exercicesSharedData.state != .completed, isDancing else { return }

            let duration = robotManager.movementDance()

            DispatchQueue.main.asyncAfter(
                deadline: .now() + duration,
                execute: {
                    self.robotMovement()
                })
        }
    }
}

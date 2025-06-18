// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - NewDanceFreezeCoordinator

public class NewDanceFreezeCoordinator: ExerciseSharedDataProtocol {
    // MARK: Lifecycle

    public init(songs: [DanceFreezeSong]) {
        self.songs = songs
    }

    public convenience init(model: NewDanceFreezeModel) {
        self.init(songs: model.songs)
    }

    // MARK: Public

    public private(set) var progress = CurrentValueSubject<CGFloat, Never>(0.0)
    public private(set) var isDancing = CurrentValueSubject<Bool, Never>(false)

    public func setup(audio: AudioManager.AudioType, isAuto: Bool) {
        if self.audioData != audio {
            self.audioData = audio
            self.audioManager.stop()
            self.subscribeToAudioManagerProgress()
        }
        self.isAuto = isAuto
        self.isDancing.send(true)
    }

    public func updateMotionMode(isMovementEnabled: Bool) {
        self.isMovementEnabled = isMovementEnabled
    }

    public func updateAutoMode(isAuto: Bool) {
        self.isAuto = isAuto
        if self.isAuto {
            self.randomSwitch()
        }
    }

    public func pause() {
        self.isAuto = false
        self.audioManager.pause()
        self.isDancing.send(false)
        self.robotManager.freeze()
    }

    public func switchDanceState() {
        guard self.progress.value < 1.0 else {
            self.complete()
            return
        }

        if case .playing = self.audioManager.state.value {
            self.audioManager.pause()
            self.isDancing.send(false)
            self.robotManager.freeze()
        } else {
            self.audioManager.play(self.audioData!)
            self.isDancing.send(true)
            self.robotDance()
        }
    }

    // MARK: Internal

    var didComplete: PassthroughSubject<Void, Never> = .init()

    let songs: [DanceFreezeSong]

    func complete() {
        // TODO: (@ladislas, @HPezz) Trigger didComplete on animation ended
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            logGEK.debug("Exercise completed")
            self.didComplete.send()
        }
        self.isDancing.send(false)
        self.isComplete = true
        self.robotManager.stopRobot()
        self.audioManager.stop()
    }

    // MARK: Private

    private var robotManager = DanceFreezeRobotManager()
    private var audioManager: AudioManager = .shared
    private var audioData: AudioManager.AudioType?
    private var isMovementEnabled: Bool = false
    private var isAuto: Bool = false
    private var isComplete: Bool = false
    private var cancellables: Set<AnyCancellable> = []

    private func subscribeToAudioManagerProgress() {
        self.audioManager.progress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.progress.send($0.percentage)
                if self.progress.value >= 1.0 {
                    self.complete()
                }
            }
            .store(in: &self.cancellables)
    }

    private func randomSwitch() {
        if !self.isComplete, self.isAuto {
            let rand = Double.random(in: 3..<(self.isDancing.value ? 8 : 5))

            DispatchQueue.main.asyncAfter(deadline: .now() + rand) {
                if !self.isComplete, self.isAuto {
                    self.switchDanceState()
                    self.randomSwitch()
                }
            }
        }
    }

    private func robotDance() {
        if self.isMovementEnabled {
            self.robotMovement()
        } else {
            self.robotRotation()
        }

        self.robotLightFrenzy()
    }

    private func robotLightFrenzy() {
        guard self.isDancing.value, !self.isComplete else { return }

        self.robotManager.shineRandomly()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.robotLightFrenzy()
        }
    }

    private func robotRotation() {
        guard self.isDancing.value, !self.isComplete else { return }

        let duration = self.robotManager.rotationDance()

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.robotRotation()
        }
    }

    private func robotMovement() {
        guard self.isDancing.value, !self.isComplete else { return }

        let duration = self.robotManager.movementDance()

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.robotMovement()
        }
    }
}

#Preview {
    let songs = [
        DanceFreezeSong(song: "Giggly_Squirrel"),
        DanceFreezeSong(song: "Empty_Page"),
        DanceFreezeSong(song: "Early_Bird"),
        DanceFreezeSong(song: "Hands_On"),
        DanceFreezeSong(song: "In_The_Game"),
        DanceFreezeSong(song: "Little_by_little"),
    ]
    let coordinator = NewDanceFreezeCoordinator(songs: songs)
    let viewModel = NewDanceFreezeViewViewModel(coordinator: coordinator)

    return NewDanceFreezeView(viewModel: viewModel)
}

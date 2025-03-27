// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
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
    public private(set) var isAuto = CurrentValueSubject<Bool, Never>(false)

    public func setupDanceFreeze(audio: AudioManager.AudioType, motion: DanceFreezeMotion, stage: DanceFreezeStage) {
        self.audioData = audio
        self.motionMode = motion
        self.isDancing.send(true)
        self.subscribeToAudioManagerProgress()
        if stage == .automaticMode {
            self.isAuto.send(true)
            self.randomSwitch()
        }
    }

    public func processDanceFreezeToggle() {
        guard self.progress.value < 1.0 else {
            self.completeDanceFreeze()
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

    func completeDanceFreeze() {
        self.isDancing.send(false)
        self.didComplete.send()
        self.isComplete = true
        self.robotManager.stopRobot()
        self.audioManager.stop()
    }

    // MARK: Private

    private var robotManager = DanceFreezeRobotManager()
    private var audioManager: AudioManager = .shared
    private var audioData: AudioManager.AudioType?
    private var motionMode: DanceFreezeMotion = .rotation
    private var isComplete: Bool = false
    private var cancellables: Set<AnyCancellable> = []

    private func subscribeToAudioManagerProgress() {
        self.audioManager.progress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.progress.send($0.percentage)
                if self.progress.value >= 1.0 {
                    self.completeDanceFreeze()
                }
            }
            .store(in: &self.cancellables)
    }

    private func randomSwitch() {
        if !self.isComplete {
            let rand = Double.random(in: 3..<(self.isDancing.value ? 8 : 5))

            DispatchQueue.main.asyncAfter(deadline: .now() + rand) {
                if !self.isComplete {
                    self.processDanceFreezeToggle()
                    self.randomSwitch()
                }
            }
        }
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

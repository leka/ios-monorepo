// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

@Observable
class NewDanceFreezeViewViewModel {
    // MARK: Lifecycle

    init(coordinator: NewDanceFreezeCoordinator) {
        self.coordinator = coordinator
        self.songs = coordinator.songs
        self.coordinator.progress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.progress = $0
            }
            .store(in: &self.cancellables)
        self.coordinator.isDancing
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.isDancing = $0
            }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    var progress: CGFloat = 0.0
    var isDancing: Bool = false

    let songs: [DanceFreezeSong]

    func setup(audio: AudioManager.AudioType, isAuto: Bool) {
        self.coordinator.setup(audio: audio, isAuto: isAuto)
    }

    func updateMotionMode(isMovementEnabled: Bool) {
        self.coordinator.updateMotionMode(isMovementEnabled: isMovementEnabled)
    }

    func updateAutoMode(isAuto: Bool) {
        self.coordinator.updateAutoMode(isAuto: isAuto)
    }

    func pause() {
        self.coordinator.pause()
    }

    func onSwitchDanceState() {
        self.coordinator.switchDanceState()
    }

    func complete() {
        self.coordinator.complete()
    }

    // MARK: Private

    private let coordinator: NewDanceFreezeCoordinator
    private var cancellables: Set<AnyCancellable> = []
}

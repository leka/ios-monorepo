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
        self.coordinator.isAuto
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.isAuto = $0
            }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    var progress: CGFloat = 0.0
    var isDancing: Bool = false
    var isAuto: Bool = false

    let songs: [DanceFreezeSong]

    func setupDanceFreeze(audio: AudioManager.AudioType, motion: DanceFreezeMotion, stage: DanceFreezeStage) {
        self.coordinator.setupDanceFreeze(audio: audio, motion: motion, stage: stage)
    }

    func onDanceFreezeToggle() {
        self.coordinator.processDanceFreezeToggle()
    }

    func completeDanceFreeze() {
        self.coordinator.completeDanceFreeze()
    }

    // MARK: Private

    private let coordinator: NewDanceFreezeCoordinator
    private var cancellables: Set<AnyCancellable> = []
}

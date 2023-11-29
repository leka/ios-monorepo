// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class MelodyViewModel: Identifiable, ObservableObject {
    public var gameplay: MelodyGameplay

    @Published public var progress: CGFloat
    @Published var state: ExerciseState

    private var cancellables: Set<AnyCancellable> = []

    public init(gameplay: MelodyGameplay) {
        self.gameplay = gameplay

        self.progress = self.gameplay.progress
        self.state = self.gameplay.state

        self.gameplay.$progress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.progress = $0
            }
            .store(in: &cancellables)

        self.gameplay.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.state = $0
            }
            .store(in: &cancellables)
    }

    public func onTileTapped(tile: XylophoneTile) {
        gameplay.process(tile: tile)
    }
}

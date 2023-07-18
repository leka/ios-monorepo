// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class SevenTilesXylophoneViewModel: Identifiable, ObservableObject {
    public let name = "Seven Tiles Xylophone"
    public var gameplay: GameplaySelectTheRightMelody

    @Published public var progress: CGFloat = 0.0
    @Published public var isFinished = false

    private var cancellables: Set<AnyCancellable> = []

    public init(gameplay: GameplaySelectTheRightMelody) {
        self.gameplay = gameplay

        self.gameplay.progressPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.progress = $0
            }
            .store(in: &cancellables)

        self.gameplay.isFinishedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.isFinished = $0
            }
            .store(in: &cancellables)
    }

    public func onTileTapped(tile: Color) {
        gameplay.process(tile: tile)
    }
}

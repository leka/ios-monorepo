// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class MelodyGameplay {
    let song: MelodySongModel
    @Published private var step = 0
    @Published public var progress: CGFloat = 0.0
    @Published public var state: GameplayState = .idle

    public init(song: MelodySongModel) {
        self.song = song
        self.state = .playing
    }

    func process(tile: XylophoneTile) {
            step += 1
            progress = CGFloat(step) / CGFloat(song.duration)
        }

        if progress == 1.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.state = .finished
            }
        }
    }
}

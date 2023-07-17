// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class GameplaySelectTheRightMelody {
    public let name = "Select The Right Melody"
    let rightAnswers: [Color]
    @Published private var step = 0
    @Published public var progress: CGFloat = 0.0
    @Published public var isFinished: Bool = false

    public var progressPublisher: Published<CGFloat>.Publisher { $progress }
    public var isFinishedPublisher: Published<Bool>.Publisher { $isFinished }

    public init(rightAnswers: [Color]) {
        self.rightAnswers = rightAnswers
    }

    public func process(tile: Color) {
        guard step < rightAnswers.count else { return }
        if tile == rightAnswers[step] {
            print("Play music")
            step += 1
            progress = CGFloat(step) / CGFloat(rightAnswers.count)
        }

        if progress == 1.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.isFinished = true
                self.step = 0
                self.progress = 0.0
            }
        }
    }
}

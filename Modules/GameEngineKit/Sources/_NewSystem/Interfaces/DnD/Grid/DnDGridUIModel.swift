// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SpriteKit
import SwiftUI

// MARK: - DnDGridViewUIChoicesWrapper

public struct DnDGridUIModel {
    static let zero = DnDGridUIModel(action: nil, choices: [])

    var action: Exercise.Action?
    var choices: [DnDAnswerNode]

    // swiftlint:disable cyclomatic_complexity

    func choiceSize(for numberOfChoices: Int) -> CGSize {
        switch self.action {
            case .ipad(type: .image),
                 .ipad(type: .sfsymbol):
                switch numberOfChoices {
                    case 1...4:
                        CGSize(width: 180, height: 180)
                    case 5...6:
                        CGSize(width: 150, height: 150)
                    default:
                        CGSize(width: 150, height: 150)
                }
            case .none:
                switch numberOfChoices {
                    case 1...2:
                        CGSize(width: 300, height: 300)
                    case 3...4:
                        CGSize(width: 240, height: 240)
                    case 5...6:
                        CGSize(width: 200, height: 200)
                    default:
                        CGSize(width: 200, height: 200)
                }
            default:
                switch numberOfChoices {
                    case 1...2:
                        CGSize(width: 220, height: 220)
                    case 3...4:
                        CGSize(width: 200, height: 200)
                    case 5:
                        CGSize(width: 160, height: 160)
                    case 6:
                        CGSize(width: 150, height: 150)
                    default:
                        CGSize(width: 150, height: 150)
                }
        }
    }

    // swiftlint:enable cyclomatic_complexity
}

// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

// swiftlint:disable cyclomatic_complexity

// MARK: - DnDOneToOneUIModel

public struct DnDOneToOneUIModel {
    static let zero = DnDOneToOneUIModel(action: nil, choices: [])

    var action: Exercise.Action?
    var choices: [DnDAnswerNode]

    func choiceSize(for numberOfChoices: Int) -> CGSize {
        switch self.action {
            case .ipad(type: .image),
                 .ipad(type: .sfsymbol):
                switch numberOfChoices {
                    case 1:
                        CGSize(width: 200, height: 200)
                    case 2:
                        CGSize(width: 160, height: 160)
                    case 3:
                        CGSize(width: 130, height: 130)
                    case 4:
                        CGSize(width: 110, height: 110)
                    case 5:
                        CGSize(width: 90, height: 90)
                    default:
                        CGSize(width: 75, height: 75)
                }
            case .none:
                switch numberOfChoices {
                    case 1...3:
                        CGSize(width: 220, height: 220)
                    case 4:
                        CGSize(width: 200, height: 200)
                    case 5:
                        CGSize(width: 170, height: 170)
                    default:
                        CGSize(width: 150, height: 150)
                }
            case .ipad(type: .audio),
                 .ipad(type: .speech),
                 .robot:
                switch numberOfChoices {
                    case 1...2:
                        CGSize(width: 200, height: 200)
                    case 3:
                        CGSize(width: 180, height: 180)
                    case 4:
                        CGSize(width: 160, height: 160)
                    case 5:
                        CGSize(width: 130, height: 130)
                    default:
                        CGSize(width: 110, height: 110)
                }
            default:
                CGSize(width: 75, height: 75)
        }
    }
}

// swiftlint:enable cyclomatic_complexity

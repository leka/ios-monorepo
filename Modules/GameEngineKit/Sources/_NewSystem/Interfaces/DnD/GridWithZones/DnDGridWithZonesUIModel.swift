// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SpriteKit
import SwiftUI

// MARK: - DnDGridWithZonesUIModel

public struct DnDGridWithZonesUIModel {
    static let zero = DnDGridWithZonesUIModel(action: nil, choices: [])

    var action: Exercise.Action?
    var choices: [DnDAnswerNode]

    // swiftlint:disable cyclomatic_complexity

    func choiceSize(for numberOfChoices: Int) -> CGSize {
        switch self.action {
            case .ipad(type: .image),
                 .ipad(type: .sfsymbol):
                switch numberOfChoices {
                    case 1...2:
                        CGSize(width: 170, height: 170)
                    case 3:
                        CGSize(width: 150, height: 150)
                    case 4:
                        CGSize(width: 120, height: 120)
                    case 5:
                        CGSize(width: 100, height: 100)
                    default:
                        CGSize(width: 80, height: 80)
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
                        CGSize(width: 140, height: 140)
                    default:
                        CGSize(width: 100, height: 100)
                }
            default:
                CGSize(width: 80, height: 80)
        }
    }

    // swiftlint:enable cyclomatic_complexity
}

// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SpriteKit
import SwiftUI

// MARK: - DnDGridViewUIChoicesWrapper

public struct DnDGridUIModel {
    // MARK: Internal

    static let zero = DnDGridUIModel(action: nil, choices: [])

    var action: Exercise.Action?
    var choices: [DnDAnswerNode]

    func choiceSize(for choiceNumber: Int) -> CGSize {
        DnDGridSize(choiceNumber).choiceSize(for: self.action)
    }

    // MARK: Private

    // swiftlint:disable identifier_name cyclomatic_complexity

    private enum DnDGridSize: Int {
        case one = 1
        case two
        case three
        case four
        case five
        case six
        case none

        // MARK: Lifecycle

        init(_ rawValue: Int) {
            self = DnDGridSize(rawValue: rawValue) ?? .none
        }

        // MARK: Internal

        func choiceSize(for action: Exercise.Action?) -> CGSize {
            switch action {
                case .ipad(type: .image),
                     .ipad(type: .sfsymbol):
                    switch self {
                        case .one,
                             .two,
                             .three,
                             .four:
                            CGSize(width: 180, height: 180)
                        case .five,
                             .six,
                             .none:
                            CGSize(width: 150, height: 150)
                    }
                case .none:
                    switch self {
                        case .one,
                             .two:
                            CGSize(width: 300, height: 300)
                        case .three,
                             .four:
                            CGSize(width: 240, height: 240)
                        case .five,
                             .six,
                             .none:
                            CGSize(width: 200, height: 200)
                    }
                default:
                    switch self {
                        case .one,
                             .two:
                            CGSize(width: 220, height: 220)
                        case .three,
                             .four:
                            CGSize(width: 200, height: 200)
                        case .five:
                            CGSize(width: 160, height: 160)
                        case .six,
                             .none:
                            CGSize(width: 150, height: 150)
                    }
            }
        }
    }

    // swiftlint:enable identifier_name cyclomatic_complexity
}

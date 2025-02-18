// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - TTSUIChoiceModel

public struct TTSUIChoiceModel: Identifiable {
    // MARK: Lifecycle

    init(id: UUID = UUID(), view: some View = EmptyView(), disabled: Bool = false) {
        self.id = id
        self.view = AnyView(view)
        self.disabled = disabled
    }

    // MARK: Public

    public let id: UUID

    // MARK: Internal

    let view: AnyView
    let disabled: Bool
}

// MARK: - TTSUIModel

public struct TTSUIModel {
    static let zero = TTSUIModel(action: nil, choices: [])

    var action: Exercise.Action?
    var choices: [TTSUIChoiceModel]

    // swiftlint:disable cyclomatic_complexity

    func choiceSize(for numberOfChoices: Int) -> CGFloat {
        switch self.action {
            case .ipad(type: .image),
                 .ipad(type: .sfsymbol):
                switch numberOfChoices {
                    case 1:
                        250
                    case 2...4:
                        180
                    case 5...6:
                        120
                    default:
                        120
                }
            case .none:
                switch numberOfChoices {
                    case 1...2:
                        300
                    case 3...6:
                        240
                    default:
                        240
                }
            case .ipad(type: .audio),
                 .ipad(type: .speech),
                 .robot:
                switch numberOfChoices {
                    case 1...2:
                        300
                    case 3...4:
                        240
                    case 5...6:
                        190
                    default:
                        190
                }
            default:
                140
        }
    }

    // swiftlint:enable cyclomatic_complexity
}

// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import DeviceKit
import SwiftUI

// MARK: - MemoryUIChoiceModel

public struct MemoryUIChoiceModel: Identifiable {
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

// MARK: - MemoryUIModel

public struct MemoryUIModel {
    static let zero = MemoryUIModel(choices: [])

    var choices: [MemoryUIChoiceModel]

    // swiftlint:disable cyclomatic_complexity

    func choiceSize(for numberOfChoices: Int) -> CGFloat {
        switch Device.current.getDeviceSize() {
            case .small:
                switch numberOfChoices {
                    case 1...2:
                        300
                    case 3...6:
                        230
                    case 7...8:
                        210
                    default:
                        200
                }
            case .medium:
                switch numberOfChoices {
                    case 1...2:
                        350
                    case 3:
                        270
                    case 4...6:
                        260
                    case 7...8:
                        220
                    default:
                        220
                }
            case .large:
                switch numberOfChoices {
                    case 1...2:
                        450
                    case 3...6:
                        350
                    case 5...6:
                        320
                    case 7...8:
                        280
                    default:
                        250
                }
        }
    }
}

// swiftlint:enable cyclomatic_complexity

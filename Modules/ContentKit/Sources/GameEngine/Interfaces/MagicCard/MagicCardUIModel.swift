// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import DeviceKit
import SwiftUI
import UtilsKit

// MARK: - MagicCardUIChoiceModel

public struct MagicCardUIChoiceModel: Identifiable {
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

// MARK: - MagicCardUIModel

public struct MagicCardUIModel {
    static let zero = MagicCardUIModel(action: nil, choices: [])

    var action: NewExerciseAction?
    var choices: [MagicCardUIChoiceModel]

    // swiftlint:disable cyclomatic_complexity function_body_length

    func choiceSize(for numberOfChoices: Int) -> CGFloat {
        switch Device.current.getDeviceSize() {
            case .small:
                switch self.action {
                    case .ipad(type: .image),
                         .ipad(type: .sfsymbol):
                        switch numberOfChoices {
                            case 1...2:
                                250
                            case 3...4:
                                220
                            case 5...6:
                                180
                            default:
                                180
                        }
                    case .none:
                        switch numberOfChoices {
                            case 1...3:
                                300
                            case 4...6:
                                250
                            default:
                                250
                        }
                    case .ipad(type: .audio),
                         .ipad(type: .speech),
                         .robot:
                        switch numberOfChoices {
                            case 1...3:
                                300
                            case 4:
                                250
                            case 5...6:
                                230
                            default:
                                230
                        }
                    default:
                        180
                }
            case .medium:
                switch self.action {
                    case .ipad(type: .image),
                         .ipad(type: .sfsymbol):
                        switch numberOfChoices {
                            case 1:
                                250
                            case 2...4:
                                200
                            case 5...6:
                                180
                            default:
                                180
                        }
                    case .none:
                        switch numberOfChoices {
                            case 1...2:
                                300
                            case 3...6:
                                250
                            default:
                                250
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
                                230
                            default:
                                230
                        }
                    default:
                        180
                }
            case .large:
                switch self.action {
                    case .ipad(type: .image),
                         .ipad(type: .sfsymbol):
                        switch numberOfChoices {
                            case 1:
                                300
                            case 2...4:
                                280
                            case 5...6:
                                250
                            default:
                                230
                        }
                    case .none:
                        switch numberOfChoices {
                            case 1...2:
                                300
                            case 3...6:
                                340
                            default:
                                340
                        }
                    case .ipad(type: .audio),
                         .ipad(type: .speech),
                         .robot:
                        switch numberOfChoices {
                            case 1...2:
                                400
                            case 3...4:
                                340
                            case 5...6:
                                320
                            default:
                                300
                        }
                    default:
                        140
                }
        }
    }

    // swiftlint:enable cyclomatic_complexity function_body_length
}

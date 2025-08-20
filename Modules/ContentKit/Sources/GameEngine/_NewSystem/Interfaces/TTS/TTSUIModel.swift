// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import DeviceKit
import SwiftUI
import UtilsKit

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

    var action: NewExerciseAction?
    var choices: [TTSUIChoiceModel]

    // swiftlint:disable cyclomatic_complexity function_body_length

    func choiceSize(for numberOfChoices: Int) -> CGFloat {
        switch Device.current.getDeviceSize() {
            case .small:
                switch self.action {
                    case .ipad(type: .image),
                         .ipad(type: .sfsymbol):
                        switch numberOfChoices {
                            case 1:
                                250
                            case 2...4:
                                180
                            case 5...6:
                                140
                            default:
                                140
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
            case .medium:
                switch self.action {
                    case .ipad(type: .image),
                         .ipad(type: .sfsymbol):
                        switch numberOfChoices {
                            case 1:
                                270
                            case 2...4:
                                230
                            case 5...6:
                                150
                            default:
                                150
                        }
                    case .none:
                        switch numberOfChoices {
                            case 1...2:
                                320
                            case 3...6:
                                260
                            default:
                                260
                        }
                    case .ipad(type: .audio),
                         .ipad(type: .speech),
                         .robot:
                        switch numberOfChoices {
                            case 1...2:
                                320
                            case 3...4:
                                260
                            case 5...6:
                                220
                            default:
                                220
                        }
                    default:
                        150
                }
            case .large:
                switch self.action {
                    case .ipad(type: .image),
                         .ipad(type: .sfsymbol):
                        switch numberOfChoices {
                            case 1:
                                350
                            case 2...4:
                                270
                            case 5...6:
                                230
                            default:
                                230
                        }
                    case .none:
                        switch numberOfChoices {
                            case 1...2:
                                370
                            case 3...6:
                                310
                            default:
                                310
                        }
                    case .ipad(type: .audio),
                         .ipad(type: .speech),
                         .robot:
                        switch numberOfChoices {
                            case 1...2:
                                370
                            case 3...4:
                                310
                            case 5...6:
                                260
                            default:
                                260
                        }
                    default:
                        230
                }
        }
    }

    // swiftlint:enable cyclomatic_complexity function_body_length
}

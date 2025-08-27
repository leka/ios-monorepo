// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DeviceKit
import SpriteKit
import SwiftUI
import UtilsKit

// MARK: - DnDGridWithZonesUIModel

public struct DnDGridWithZonesUIModel {
    static let zero = DnDGridWithZonesUIModel(action: nil, choices: [])

    var action: NewExerciseAction?
    var choices: [DnDAnswerNode]

    // swiftlint:disable cyclomatic_complexity function_body_length

    func choiceSize(for numberOfChoices: Int) -> CGSize {
        switch Device.current.getDeviceSize() {
            case .small:
                switch self.action {
                    case .ipad(type: .image),
                         .ipad(type: .sfsymbol):
                        switch numberOfChoices {
                            case 1...2:
                                CGSize(width: 170, height: 170)
                            case 3:
                                CGSize(width: 140, height: 140)
                            case 4:
                                CGSize(width: 110, height: 110)
                            case 5:
                                CGSize(width: 90, height: 90)
                            case 6:
                                CGSize(width: 80, height: 80)
                            default:
                                CGSize(width: 80, height: 80)
                        }
                    case .none:
                        switch numberOfChoices {
                            case 1...4:
                                CGSize(width: 200, height: 200)
                            case 5:
                                CGSize(width: 170, height: 170)
                            case 6:
                                CGSize(width: 150, height: 150)
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
                            case 6:
                                CGSize(width: 110, height: 110)
                            default:
                                CGSize(width: 100, height: 100)
                        }
                    default:
                        CGSize(width: 80, height: 80)
                }
            case .medium:
                switch self.action {
                    case .ipad(type: .image),
                         .ipad(type: .sfsymbol):
                        switch numberOfChoices {
                            case 1...2:
                                CGSize(width: 170, height: 170)
                            case 3:
                                CGSize(width: 140, height: 140)
                            case 4:
                                CGSize(width: 110, height: 110)
                            case 5:
                                CGSize(width: 90, height: 90)
                            case 6:
                                CGSize(width: 80, height: 80)
                            default:
                                CGSize(width: 80, height: 80)
                        }
                    case .none:
                        switch numberOfChoices {
                            case 1...4:
                                CGSize(width: 200, height: 200)
                            case 5:
                                CGSize(width: 170, height: 170)
                            case 6:
                                CGSize(width: 150, height: 150)
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
                            case 6:
                                CGSize(width: 110, height: 110)
                            default:
                                CGSize(width: 100, height: 100)
                        }
                    default:
                        CGSize(width: 80, height: 80)
                }
            case .large:
                switch self.action {
                    case .ipad(type: .image),
                         .ipad(type: .sfsymbol):
                        switch numberOfChoices {
                            case 1...2:
                                CGSize(width: 250, height: 250)
                            case 3:
                                CGSize(width: 190, height: 190)
                            case 4:
                                CGSize(width: 160, height: 160)
                            case 5:
                                CGSize(width: 130, height: 130)
                            case 6:
                                CGSize(width: 110, height: 110)
                            default:
                                CGSize(width: 100, height: 100)
                        }
                    case .none:
                        switch numberOfChoices {
                            case 1...3:
                                CGSize(width: 280, height: 280)
                            case 4:
                                CGSize(width: 240, height: 240)
                            case 5:
                                CGSize(width: 200, height: 200)
                            case 6:
                                CGSize(width: 180, height: 180)
                            default:
                                CGSize(width: 150, height: 150)
                        }
                    case .ipad(type: .audio),
                         .ipad(type: .speech),
                         .robot:
                        switch numberOfChoices {
                            case 1...2:
                                CGSize(width: 280, height: 280)
                            case 3:
                                CGSize(width: 260, height: 260)
                            case 4:
                                CGSize(width: 220, height: 220)
                            case 5:
                                CGSize(width: 180, height: 180)
                            case 6:
                                CGSize(width: 150, height: 150)
                            default:
                                CGSize(width: 140, height: 140)
                        }
                    default:
                        CGSize(width: 100, height: 100)
                }
        }
    }
    // swiftlint:enable cyclomatic_complexity function_body_length
}

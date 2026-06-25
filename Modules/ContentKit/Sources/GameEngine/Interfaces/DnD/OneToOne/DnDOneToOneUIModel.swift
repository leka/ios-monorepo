// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DeviceKit
import SpriteKit
import SwiftUI
import UtilsKit

// swiftlint:disable cyclomatic_complexity function_body_length

// MARK: - DnDOneToOneUIModel

public struct DnDOneToOneUIModel {
    static let zero = DnDOneToOneUIModel(action: nil, choices: [])

    var action: NewExerciseAction?
    var choices: [DnDAnswerNode]

    func choiceSize(for numberOfChoices: Int) -> CGSize {
        switch Device.current.getDeviceSize() {
            case .small:
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
                            case 1...4:
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
            case .medium:
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
            case .large:
                switch self.action {
                    case .ipad(type: .image),
                         .ipad(type: .sfsymbol):
                        switch numberOfChoices {
                            case 1...2:
                                CGSize(width: 250, height: 250)
                            case 3:
                                CGSize(width: 170, height: 170)
                            case 4:
                                CGSize(width: 150, height: 150)
                            case 5:
                                CGSize(width: 130, height: 130)
                            case 6:
                                CGSize(width: 110, height: 110)
                            default:
                                CGSize(width: 110, height: 110)
                        }
                    case .none:
                        switch numberOfChoices {
                            case 1...3:
                                CGSize(width: 300, height: 300)
                            case 4:
                                CGSize(width: 250, height: 250)
                            case 5:
                                CGSize(width: 200, height: 200)
                            case 6:
                                CGSize(width: 170, height: 170)
                            default:
                                CGSize(width: 170, height: 170)
                        }
                    case .ipad(type: .audio),
                         .ipad(type: .speech),
                         .robot:
                        switch numberOfChoices {
                            case 1...3:
                                CGSize(width: 250, height: 250)
                            case 4:
                                CGSize(width: 200, height: 200)
                            case 5:
                                CGSize(width: 180, height: 180)
                            case 6:
                                CGSize(width: 150, height: 150)
                            default:
                                CGSize(width: 150, height: 150)
                        }
                    default:
                        CGSize(width: 110, height: 110)
                }
        }
    }
}

// swiftlint:enable cyclomatic_complexity function_body_length

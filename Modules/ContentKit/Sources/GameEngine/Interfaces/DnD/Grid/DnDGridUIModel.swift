// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DeviceKit
import SpriteKit
import SwiftUI
import UtilsKit

// MARK: - DnDGridViewUIChoicesWrapper

public struct DnDGridUIModel {
    static let zero = DnDGridUIModel(action: nil, choices: [])

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
                                CGSize(width: 200, height: 200)
                            case 3...4:
                                CGSize(width: 170, height: 170)
                            case 5...6:
                                CGSize(width: 150, height: 150)
                            default:
                                CGSize(width: 150, height: 150)
                        }
                    case .none:
                        switch numberOfChoices {
                            case 1...2:
                                CGSize(width: 300, height: 300)
                            case 3:
                                CGSize(width: 250, height: 250)
                            case 4:
                                CGSize(width: 220, height: 220)
                            case 5...6:
                                CGSize(width: 200, height: 200)
                            default:
                                CGSize(width: 200, height: 200)
                        }
                    case .ipad(type: .audio),
                         .ipad(type: .speech),
                         .robot:
                        switch numberOfChoices {
                            case 1...2:
                                CGSize(width: 270, height: 270)
                            case 3...6:
                                CGSize(width: 220, height: 220)
                            default:
                                CGSize(width: 220, height: 220)
                        }
                    default:
                        CGSize(width: 150, height: 150)
                }
            case .medium:
                switch self.action {
                    case .ipad(type: .image),
                         .ipad(type: .sfsymbol):
                        switch numberOfChoices {
                            case 1...2:
                                CGSize(width: 250, height: 250)
                            case 3...4:
                                CGSize(width: 220, height: 220)
                            case 5...6:
                                CGSize(width: 170, height: 170)
                            default:
                                CGSize(width: 170, height: 170)
                        }
                    case .none:
                        switch numberOfChoices {
                            case 1...2:
                                CGSize(width: 350, height: 350)
                            case 3...6:
                                CGSize(width: 250, height: 250)
                            default:
                                CGSize(width: 250, height: 250)
                        }
                    case .ipad(type: .audio),
                         .ipad(type: .speech),
                         .robot:
                        switch numberOfChoices {
                            case 1...2:
                                CGSize(width: 320, height: 320)
                            case 3...6:
                                CGSize(width: 250, height: 250)
                            default:
                                CGSize(width: 250, height: 250)
                        }
                    default:
                        CGSize(width: 170, height: 170)
                }
            case .large:
                switch self.action {
                    case .ipad(type: .image),
                         .ipad(type: .sfsymbol):
                        switch numberOfChoices {
                            case 1...2:
                                CGSize(width: 300, height: 300)
                            case 3...4:
                                CGSize(width: 270, height: 270)
                            case 5...6:
                                CGSize(width: 250, height: 250)
                            default:
                                CGSize(width: 250, height: 250)
                        }
                    case .none:
                        switch numberOfChoices {
                            case 1...2:
                                CGSize(width: 400, height: 400)
                            case 3...6:
                                CGSize(width: 300, height: 300)
                            default:
                                CGSize(width: 300, height: 300)
                        }
                    case .ipad(type: .audio),
                         .ipad(type: .speech),
                         .robot:
                        switch numberOfChoices {
                            case 1...2:
                                CGSize(width: 350, height: 350)
                            case 3...4:
                                CGSize(width: 300, height: 300)
                            case 5...6:
                                CGSize(width: 280, height: 280)
                            default:
                                CGSize(width: 280, height: 280)
                        }
                    default:
                        CGSize(width: 250, height: 250)
                }
        }
    }

    // swiftlint:enable cyclomatic_complexity function_body_length
}

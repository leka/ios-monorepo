// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DeviceKit
import SpriteKit
import SwiftUI
import UtilsKit

// MARK: - DnDGridWithZonesUIDropzoneModel

public struct DnDGridWithZonesUIDropzoneModel {
    static let zero = DnDGridWithZonesUIDropzoneModel(action: nil, zones: [])

    var action: NewExerciseAction?
    var zones: [DnDDropZoneNode]

    // swiftlint:disable cyclomatic_complexity function_body_length

    func zoneSize(for numberOfChoices: Int) -> CGSize {
        switch Device.current.getDeviceSize() {
            case .small:
                switch self.action {
                    case .ipad(type: .image),
                         .ipad(type: .sfsymbol):
                        switch numberOfChoices {
                            case 1:
                                CGSize(width: 300, height: 225)
                            case 2:
                                CGSize(width: 240, height: 180)
                            default:
                                CGSize(width: 180, height: 135)
                        }
                    case .none:
                        switch numberOfChoices {
                            case 1...2:
                                CGSize(width: 340, height: 255)
                            default:
                                CGSize(width: 300, height: 225)
                        }
                    case .ipad(type: .audio),
                         .ipad(type: .speech),
                         .robot:
                        switch numberOfChoices {
                            case 1...2:
                                CGSize(width: 340, height: 255)
                            default:
                                CGSize(width: 240, height: 180)
                        }
                    default:
                        CGSize(width: 180, height: 135)
                }
            case .medium:
                switch self.action {
                    case .ipad(type: .image),
                         .ipad(type: .sfsymbol):
                        switch numberOfChoices {
                            case 1:
                                CGSize(width: 300, height: 225)
                            case 2:
                                CGSize(width: 220, height: 165)
                            default:
                                CGSize(width: 160, height: 120)
                        }
                    case .none:
                        switch numberOfChoices {
                            case 1:
                                CGSize(width: 400, height: 300)
                            case 2:
                                CGSize(width: 380, height: 285)
                            default:
                                CGSize(width: 300, height: 225)
                        }
                    case .ipad(type: .audio),
                         .ipad(type: .speech),
                         .robot:
                        switch numberOfChoices {
                            case 1:
                                CGSize(width: 400, height: 300)
                            case 2:
                                CGSize(width: 320, height: 240)
                            default:
                                CGSize(width: 200, height: 150)
                        }
                    default:
                        CGSize(width: 160, height: 120)
                }
            case .large:
                switch self.action {
                    case .ipad(type: .image),
                         .ipad(type: .sfsymbol):
                        switch numberOfChoices {
                            case 1:
                                CGSize(width: 500, height: 375)
                            case 2:
                                CGSize(width: 320, height: 240)
                            default:
                                CGSize(width: 240, height: 180)
                        }
                    case .none:
                        switch numberOfChoices {
                            case 1...2:
                                CGSize(width: 500, height: 375)
                            default:
                                CGSize(width: 360, height: 270)
                        }
                    case .ipad(type: .audio),
                         .ipad(type: .speech),
                         .robot:
                        switch numberOfChoices {
                            case 1:
                                CGSize(width: 500, height: 375)
                            case 2:
                                CGSize(width: 420, height: 315)
                            default:
                                CGSize(width: 300, height: 225)
                        }
                    default:
                        CGSize(width: 180, height: 135)
                }
        }
    }
}

// swiftlint:enable cyclomatic_complexity function_body_length

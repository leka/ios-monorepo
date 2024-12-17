// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SpriteKit
import SwiftUI

// MARK: - DnDGridWithZonesUIDropzoneModel

public struct DnDGridWithZonesUIDropzoneModel {
    static let zero = DnDGridWithZonesUIDropzoneModel(action: nil, zones: [])

    var action: Exercise.Action?
    var zones: [DnDDropZoneNode]

    func zoneSize(for numberOfChoices: Int) -> CGSize {
        switch self.action {
            case .ipad(type: .image),
                 .ipad(type: .sfsymbol):
                switch numberOfChoices {
                    case 1:
                        CGSize(width: 315, height: 236.25)
                    default:
                        CGSize(width: 210, height: 157.5)
                }
            case .none:
                CGSize(width: 420, height: 315)
            case .ipad(type: .audio),
                 .ipad(type: .speech),
                 .robot:
                switch numberOfChoices {
                    case 1:
                        CGSize(width: 420, height: 315)
                    default:
                        CGSize(width: 315, height: 236.25)
                }
            default:
                CGSize(width: 210, height: 157.5)
        }
    }
}

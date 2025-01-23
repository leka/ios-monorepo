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
                        CGSize(width: 300, height: 225)
                    default:
                        CGSize(width: 200, height: 150)
                }
            case .none:
                CGSize(width: 400, height: 300)
            case .ipad(type: .audio),
                 .ipad(type: .speech),
                 .robot:
                switch numberOfChoices {
                    case 1:
                        CGSize(width: 400, height: 300)
                    default:
                        CGSize(width: 300, height: 225)
                }
            default:
                CGSize(width: 200, height: 150)
        }
    }
}

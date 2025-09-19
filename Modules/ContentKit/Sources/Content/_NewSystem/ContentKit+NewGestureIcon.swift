// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

public extension ContentKit {
    static func getNewGestureIconUIImage(for payload: NewActivityPayload) -> UIImage? {
        UIImage(named: "\(self.getNewGestureIcon(for: payload)).gesture.icon.png", in: .module, with: nil)
    }

    private static func getInterface(for payload: NewActivityPayload) -> NewExerciseInterface? {
        let allInterfaces = payload.exerciseGroups.flatMap { $0.exercises.map(\.interface) }
        let uniqueInterfaces = Set(allInterfaces)
        return uniqueInterfaces.count == 1 ? uniqueInterfaces.first : nil
    }

    private static func getNewGestureIcon(for payload: NewActivityPayload) -> String {
        let interface = self.getInterface(for: payload)
        switch interface {
            case let .general(interface):
                switch interface {
                    case .touchToSelect,
                         .memory:
                        return "touch_to_select"
                    case .dragAndDropGrid,
                         .dragAndDropGridWithZones,
                         .dragAndDropOneToOne:
                        return "drag_and_drop"
                    case .magicCards:
                        return "magic_card"
                }
            case let .specialized(interface):
                return "touch_to_select"
            default:
                return ""
        }
    }
}

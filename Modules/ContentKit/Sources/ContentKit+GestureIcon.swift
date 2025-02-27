// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

public extension ContentKit {
    static func getGestureIconUIImage(for activity: Activity) -> UIImage? {
        UIImage(named: "\(self.getGestureIcon(for: activity)).gesture.icon.png", in: .module, with: nil)
    }

    private static func getInterface(for activity: Activity) -> Exercise.Interface? {
        let allInterfaces = activity.exercisePayload.exerciseGroups.flatMap { $0.exercises.map(\.interface) }
        let uniqueInterfaces = Set(allInterfaces)
        return uniqueInterfaces.count == 1 ? uniqueInterfaces.first : nil
    }

    // TODO: (@HPezz) Add MagicCard gesture case when available
    private static func getGestureIcon(for activity: Activity) -> String {
        let interface = self.getInterface(for: activity)
        switch interface {
            case .touchToSelect,
                 .listenThenTouchToSelect,
                 .observeThenTouchToSelect,
                 .robotThenTouchToSelect,
                 .melody,
                 .memory,
                 .musicalInstruments,
                 .superSimon:
                return "touch_to_select"
            case .dragAndDropIntoZones,
                 .dragAndDropToAssociate,
                 .dragAndDropInOrder,
                 .listenThenDragAndDropIntoZones,
                 .listenThenDragAndDropToAssociate,
                 .observeThenDragAndDropIntoZones,
                 .observeThenDragAndDropToAssociate,
                 .robotThenDragAndDropIntoZones,
                 .robotThenDragAndDropToAssociate:
                return "drag_and_drop"
            default:
                return ""
        }
    }
}

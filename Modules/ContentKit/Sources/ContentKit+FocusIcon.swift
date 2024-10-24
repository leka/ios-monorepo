// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

public extension ContentKit {
    enum FocusIcon {
        case robot
        case ears
    }

    static func getFocusIconUIImage(for activity: Activity, ofType type: FocusIcon) -> UIImage? {
        let iconName = "\(self.getFocusIcon(for: activity, ofType: type)).focus.icon.png"
        return UIImage(named: iconName, in: .module, with: nil)
    }

    private static func getInterface(for activity: Activity) -> Exercise.Interface? {
        let allInterfaces = activity.exercisePayload.exerciseGroups.flatMap { $0.exercises.map(\.interface) }
        let uniqueInterfaces = Set(allInterfaces)
        return uniqueInterfaces.count == 1 ? uniqueInterfaces.first : nil
    }

    private static func getFocusIcon(for activity: Activity, ofType type: FocusIcon) -> String {
        let interface = self.getInterface(for: activity)
        switch type {
            case .robot:
                switch interface {
                    case .robotThenTouchToSelect,
                         .robotThenDragAndDropIntoZones,
                         .robotThenDragAndDropToAssociate,
                         .danceFreeze,
                         .hideAndSeek,
                         .gamepadArrowPad,
                         .gamepadColorPad,
                         .gamepadArrowPadColorPad,
                         .gamepadJoyStickColorPad,
                         .melody,
                         .musicalInstruments,
                         .superSimon:
                        return "robot"
                    default:
                        return ""
                }
            case .ears:
                switch interface {
                    case .listenThenTouchToSelect,
                         .listenThenDragAndDropIntoZones,
                         .listenThenDragAndDropToAssociate,
                         .melody,
                         .musicalInstruments,
                         .danceFreeze:
                        return "ear"
                    default:
                        return ""
                }
        }
    }
}

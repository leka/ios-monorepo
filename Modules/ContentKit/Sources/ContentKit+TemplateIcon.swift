// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

public extension ContentKit {
    static func getTemplateIconUIImage(for activity: Activity) -> UIImage? {
        UIImage(named: "\(self.getTemplateIcon(for: activity)).icon.png", in: .module, with: nil)
    }

    private static func getInterface(for activity: Activity) -> Exercise.Interface? {
        let allInterfaces = activity.exercisePayload.exerciseGroups.flatMap { $0.exercises.map(\.interface) }
        let uniqueInterfaces = Set(allInterfaces)
        return uniqueInterfaces.count == 1 ? uniqueInterfaces.first : nil
    }

    private static func getNumberOfChoices(for activity: Activity) -> Int? {
        let allChoiceCounts = activity.exercisePayload.exerciseGroups.flatMap { group in
            group.exercises.compactMap { exercise -> Int? in
                if let payload = exercise.payload as? TouchToSelect.Payload {
                    return payload.choices.count
                } else if let payload = exercise.payload as? DragAndDropIntoZones.Payload {
                    return payload.choices.count
                } else if let payload = exercise.payload as? DragAndDropToAssociate.Payload {
                    return payload.choices.count
                } else if let payload = exercise.payload as? SuperSimon.Payload {
                    switch payload.level {
                        case .easy:
                            return 2
                        case .medium:
                            return 4
                        case .hard:
                            return 6
                    }
                } else if let payload = exercise.payload as? Memory.Payload {
                    return payload.choices.count
                } else {
                    return nil
                }
            }
        }
        let uniqueChoiceCounts = Set(allChoiceCounts)
        return uniqueChoiceCounts.count == 1 ? uniqueChoiceCounts.first : nil
    }

    // swiftlint:disable cyclomatic_complexity line_length function_body_length
    private static func getTemplateIcon(for activity: Activity) -> String {
        let interface = self.getInterface(for: activity)
        let choiceNumber = self.getNumberOfChoices(for: activity)
        switch interface {
            case .touchToSelect,
                 .listenThenTouchToSelect,
                 .observeThenTouchToSelect,
                 .robotThenTouchToSelect,
                 .dragAndDropToAssociate,
                 .listenThenDragAndDropToAssociate,
                 .observeThenDragAndDropToAssociate,
                 .robotThenDragAndDropToAssociate,
                 .superSimon,
                 .memory:
                switch choiceNumber {
                    case 1:
                        return "template_TouchToSelectOne"
                    case 2:
                        return "template_TouchToSelectTwo"
                    case 3:
                        return "template_TouchToSelectThree"
                    case 4:
                        return "template_TouchToSelectFour"
                    case 5:
                        return "template_TouchToSelectFive"
                    case 6:
                        return "template_TouchToSelectSix"
                    case 7:
                        return "template_TouchToSelectSeven"
                    case 8:
                        return "template_TouchToSelectEight"
                    case 9:
                        return "template_TouchToSelectNine"
                    case 10:
                        return "template_TouchToSelectTen"
                    default:
                        return ""
                }
            case .dragAndDropIntoZones,
                 .listenThenDragAndDropIntoZones,
                 .observeThenDragAndDropIntoZones,
                 .robotThenDragAndDropIntoZones:
                guard let payload = activity.exercisePayload.exerciseGroups[0].exercises[0].payload as? DragAndDropIntoZones.Payload else { return "" }
                if payload.dropZoneB != nil {
                    switch choiceNumber {
                        case 1:
                            return "template_DragAndDropTwoZonesOneChoice"
                        case 2:
                            return "template_DragAndDropTwoZonesTwoChoices"
                        case 3:
                            return "template_DragAndDropTwoZonesThreeChoices"
                        case 4:
                            return "template_DragAndDropTwoZonesFourChoices"
                        case 5:
                            return "template_DragAndDropTwoZonesFiveChoices"
                        case 6:
                            return "template_DragAndDropTwoZonesSixChoices"
                        default:
                            return ""
                    }
                } else {
                    switch choiceNumber {
                        case 1:
                            return "template_DragAndDropOneZoneOneChoice"
                        case 2:
                            return "template_DragAndDropOneZoneTwoChoices"
                        case 3:
                            return "template_DragAndDropOneZoneThreeChoices"
                        case 4:
                            return "template_DragAndDropOneZoneFourChoices"
                        case 5:
                            return "template_DragAndDropOneZoneFiveChoices"
                        case 6:
                            return "template_DragAndDropOneZoneSixChoices"
                        default:
                            return ""
                    }
                }
            default:
                return ""
        }
    }
    // swiftlint:enable cyclomatic_complexity line_length function_body_length
}

// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

public extension ContentKit {
    enum NewFocusIcon {
        case robot
        case ears
    }

    static func getNewFocusIconUIImage(for payload: NewActivityPayload, ofType type: NewFocusIcon) -> UIImage? {
        let iconName = "\(self.getNewFocusIcon(for: payload, ofType: type)).focus.icon.png"
        return UIImage(named: iconName, in: .module, with: nil)
    }

    private static func getAction(for payload: NewActivityPayload) -> NewExerciseAction? {
        let allActions = payload.exerciseGroups.flatMap { $0.exercises.map(\.action) }
        let uniqueActions = Set(allActions)
        guard let firstAction = uniqueActions.first, uniqueActions.count == 1 else {
            return nil
        }
        return firstAction
    }

    private static func getNewFocusIcon(for payload: NewActivityPayload, ofType _: NewFocusIcon) -> String {
        let action = self.getAction(for: payload)
        switch action {
            case let .ipad(actionType):
                switch actionType {
                    case .audio,
                         .speech:
                        return "ear"
                    case .color,
                         .sfsymbol,
                         .emoji,
                         .image:
                        return "eye"
                }
            case .robot:
                return "robot"
            default:
                return ""
        }
    }
}

// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

public extension ContentKit {
    static func getGestureUIImage(for gesture: Accessibility.Gesture) -> UIImage? {
        UIImage(named: "\(gesture.rawValue).gesture.icon.png", in: .module, with: nil)
    }

    static func getFocusUIImage(for focus: Accessibility.Focus?) -> UIImage? {
        guard let focus else { return nil }
        let iconName = "\(focus.rawValue).focus.icon.png"
        return UIImage(named: iconName, in: .module, with: nil)
    }
}

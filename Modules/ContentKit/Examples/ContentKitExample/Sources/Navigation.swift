// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - Navigation

@Observable
class Navigation {
    static let shared = Navigation()

    private(set) var currentCoordinator: ActivityCoordinator?

    private(set) var currentActivity: NewActivity? {
        didSet {
            guard let activity = currentActivity else { return }
            self.currentCoordinator = ActivityCoordinator(payload: activity.payload)
        }
    }

    func setCurrentActivity(_ activity: NewActivity) {
        self.currentActivity = activity
    }
}

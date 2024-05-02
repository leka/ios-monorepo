// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

class PersistentDataManager {
    // MARK: Internal

    static let shared = PersistentDataManager()

    @AppStorage("lastActiveTimestamp") var lastActiveTimestamp: Double = Date().timeIntervalSince1970
    @AppStorage("lastActiveCaregiverId") var lastActiveCaregiverID: String?

    var inactivityTimeoutPublisher: AnyPublisher<Bool, Never> {
        self.inactivityPeriodTimedOut.eraseToAnyPublisher()
    }

    func updateLastActiveTimestamp() {
        self.lastActiveTimestamp = Date().timeIntervalSince1970
    }

    func checkInactivity() {
        if Date().timeIntervalSince1970 - self.lastActiveTimestamp > self.inactivityThreshold {
            self.inactivityPeriodTimedOut.send(true)
            self.clearUserData()
        } else {
            self.inactivityPeriodTimedOut.send(false)
        }
    }

    func clearUserData() {
        self.lastActiveCaregiverID = nil
    }

    // MARK: Private

    #if DEVELOPER_MODE
        private let inactivityThreshold: TimeInterval = 120
    #else
        private let inactivityThreshold: TimeInterval = 600
    #endif
    private var inactivityPeriodTimedOut = PassthroughSubject<Bool, Never>()
}

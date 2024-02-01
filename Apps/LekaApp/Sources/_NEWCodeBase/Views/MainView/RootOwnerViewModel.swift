// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

class RootOwnerViewModel: ObservableObject {
    // MARK: Lifecycle

    private init() {
        // nothing to do
    }

    // MARK: Internal

    static let shared = RootOwnerViewModel()

    @Published var currentCompany: Company?

    @Published var bufferCaregiver = Caregiver()
    @Published var bufferCarereceiver = Carereceiver()

    @Published var isWelcomeViewPresented = true
    @Published var isSettingsViewPresented = false

    @Published var showConfirmDisconnection: Bool = false
    @Published var showConfirmDeleteAccount: Bool = false

    var isCompanyConnected: Bool {
        self.currentCompany != nil
    }

    func disconnect() {
        self.currentCompany = nil
    }
}

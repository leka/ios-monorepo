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

    @Published var currentCompany = Company(email: "", password: "", caregivers: [], carereceivers: [])
    @Published var isWelcomeViewPresented = false
    @Published var isSettingsViewPresented = false

    @Published var showConfirmDisconnection: Bool = false
    @Published var showConfirmDeleteAccount: Bool = false

    var isCompanyConnected: Bool {
        !self.currentCompany.email.isEmpty && !self.currentCompany.password.isEmpty
    }

    func disconnect() {
        self.currentCompany = Company(email: "", password: "", caregivers: [], carereceivers: [])
        self.isWelcomeViewPresented = true
    }
}

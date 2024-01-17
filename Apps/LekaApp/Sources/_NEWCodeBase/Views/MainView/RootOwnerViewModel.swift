// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

class RootOwnerViewModel: ObservableObject {
    static let shared = RootOwnerViewModel()

    @Published var currentCompany = Company(email: "", password: "", caregivers: [], carereceivers: [])
    @Published var isWelcomeViewPresented = true

    func disconnect() {
        self.currentCompany = Company(email: "", password: "", caregivers: [], carereceivers: [])
        self.isWelcomeViewPresented = true
    }
}

// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Firebase
import SwiftUI

// MARK: - ProfilesViewModel

public class ProfilesViewModel: ObservableObject {
    // MARK: Lifecycle

    public init(userUID: String) {
        self.userUID = userUID
    }

    // MARK: Public

    @Published public var userUID: String
    @Published public var currentCompany = Company(
        id: "",
        email: "",
        name: "",
        caregivers: [],
        carereceivers: []
    )

    // UI Updates
    @Published public var showEditCompany = false
    @Published public var showCreateCaregiver = false
    @Published public var showCreateCarereceiver = false
    @Published public var showEditCaregivers = false
    @Published public var showEditCarereceivers = false
    @Published public var isUpdating = false
}

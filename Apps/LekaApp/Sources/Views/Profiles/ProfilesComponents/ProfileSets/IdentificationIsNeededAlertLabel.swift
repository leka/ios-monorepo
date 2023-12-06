// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct IdentificationIsNeededAlertLabel: View {
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        Button {
            settings.showConnectInvite.toggle()
        } label: {
            Text("Non")
        }

        Button {
            viewRouter.currentPage = .welcome
        } label: {
            Text("Oui")
        }
    }
}

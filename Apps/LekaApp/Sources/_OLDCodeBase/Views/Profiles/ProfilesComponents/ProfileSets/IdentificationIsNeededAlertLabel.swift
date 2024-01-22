// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct IdentificationIsNeededAlertLabel: View {
    @EnvironmentObject var settings: SettingsViewModelDeprecated
    @EnvironmentObject var viewRouter: ViewRouterDeprecated

    var body: some View {
        Button {
            self.settings.showConnectInvite.toggle()
        } label: {
            Text("Non")
        }

        Button {
            self.viewRouter.currentPage = .welcome
        } label: {
            Text("Oui")
        }
    }
}

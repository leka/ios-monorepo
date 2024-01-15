// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

enum AccountCreationProcess {
    struct NavigationTitle: View {
        var body: some View {
            Text(l10n.AccountCreationView.navigationTitle)
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.headline)
        }
    }
}

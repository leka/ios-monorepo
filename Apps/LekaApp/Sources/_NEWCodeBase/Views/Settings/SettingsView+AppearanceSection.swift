// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - SettingsView.AppearanceSection

extension SettingsView {
    struct AppearanceSection: View {
        var body: some View {
            Section(String(l10n.SettingsView.AppearanceSection.header.characters)) {
                AppearanceRow()
                AccentColorRow()
            }
        }
    }
}

#Preview {
    Form {
        SettingsView.AppearanceSection()
    }
}

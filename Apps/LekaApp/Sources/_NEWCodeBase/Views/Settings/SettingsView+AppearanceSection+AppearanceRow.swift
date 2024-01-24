// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - SettingsView.AppearanceSection

extension SettingsView.AppearanceSection {
    struct AppearanceRow: View {
        // MARK: Internal

        @ObservedObject var styleManager: StyleManager = .shared

        var body: some View {
            HStack(spacing: 10) {
                Text(l10n.SettingsView.AppearanceSection.AppearanceRow.title)

                Spacer()

                Toggle("", isOn: Binding(
                    get: { self.styleManager.colorScheme == .dark },
                    set: { self.styleManager.colorScheme = $0 ? .dark : .light }
                ))
            }
        }

        // MARK: Private

        private var selectedColorScheme: ColorScheme {
            self.styleManager.colorScheme
        }
    }
}

#Preview {
    Form {
        SettingsView.AppearanceSection()
    }
}

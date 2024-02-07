// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CaregiverSettingsView.AppearanceRow

extension CaregiverSettingsView {
    struct AppearanceRow: View {
        // MARK: Internal

        @Binding var caregiver: Caregiver

        var body: some View {
            HStack(spacing: 10) {
                Text(l10n.CaregiverSettingsView.AppearanceRow.title)

                Spacer()

                Toggle("", isOn: Binding(
                    get: { self.styleManager.colorScheme == .dark },
                    set: {
                        self.styleManager.colorScheme = $0 ? .dark : .light
                        self.caregiver.preferredColorScheme = $0 ? .dark : .light
                    }
                ))
            }
        }

        // MARK: Private

        @ObservedObject private var styleManager: StyleManager = .shared
    }
}

#Preview {
    Form {
        CaregiverSettingsView.AppearanceRow(caregiver: .constant(Caregiver()))
    }
}

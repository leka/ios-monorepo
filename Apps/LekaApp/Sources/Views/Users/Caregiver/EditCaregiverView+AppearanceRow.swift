// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - EditCaregiverView.AppearanceRow

extension EditCaregiverView {
    struct AppearanceRow: View {
        // MARK: Internal

        var styleManager: StyleManager = .shared
        @Binding var caregiver: Caregiver

        var body: some View {
            HStack(spacing: 10) {
                Text(l10n.EditCaregiverView.AppearanceRow.title)

                Spacer()

                Toggle("", isOn: Binding(
                    get: { self.styleManager.colorScheme == .dark },
                    set: {
                        self.styleManager.colorScheme = $0 ? .dark : .light
                        self.caregiver.colorScheme = $0 ? .dark : .light
                    }
                ))
            }
        }
    }
}

#Preview {
    Form {
        EditCaregiverView.AppearanceRow(caregiver: .constant(Caregiver()))
    }
}

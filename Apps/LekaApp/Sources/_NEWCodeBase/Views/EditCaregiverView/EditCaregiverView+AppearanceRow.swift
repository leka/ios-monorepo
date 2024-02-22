// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - EditCaregiverView.AppearanceRow

extension EditCaregiverView {
    struct AppearanceRow: View {
        // MARK: Internal

        @Binding var caregiver: Caregiver_OLD

        var body: some View {
            HStack(spacing: 10) {
                Text(l10n.EditCaregiverView.AppearanceRow.title)

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
        EditCaregiverView.AppearanceRow(caregiver: .constant(Caregiver_OLD()))
    }
}

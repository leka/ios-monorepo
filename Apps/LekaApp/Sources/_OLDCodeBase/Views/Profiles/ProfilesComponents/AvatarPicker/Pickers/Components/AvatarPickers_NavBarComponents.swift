// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - AvatarPicker_NavigationTitle

struct AvatarPicker_NavigationTitle: View {
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var company: CompanyViewModelDeprecated

    var body: some View {
        Text("Quel est ton avatar ?")
            // TODO: (@ui/ux) - Design System - replace with Leka font
            .font(.headline)
    }
}

// MARK: - AvatarPicker_AdaptiveBackButton

struct AvatarPicker_AdaptiveBackButton: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button {
            // go back without saving
            self.dismiss()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                if self.viewRouter.currentPage == .welcome {
                    Text("Retour")
                } else {
                    Text("Annuler")
                }
            }
        }
    }
}

// MARK: - AvatarPicker_ValidateButton

struct AvatarPicker_ValidateButton: View {
    @EnvironmentObject var company: CompanyViewModelDeprecated
    @Environment(\.dismiss) var dismiss

    @Binding var selected: String
    var action: () -> Void

    var body: some View {
        Button {
            self.action()
            self.dismiss()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle")
                Text("Valider la sélection")
            }
        }
        .disabled(self.selected.isEmpty)
    }
}

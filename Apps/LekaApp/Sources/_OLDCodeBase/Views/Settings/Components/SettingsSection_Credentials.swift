// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SettingsSection_Credentials: View {
    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        Section {
            Group {
                LabeledContent {
                    Text(self.company.currentCompany.mail)
                        // TODO: (@ui/ux) - Design System - replace with Leka font
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                } label: {
                    Text("Adresse mail du compte")
                }
                Link(destination: URL(string: "https://leka.io")!) {
                    Text("Modifier l'email et le mot de passe")
                        .foregroundColor(.blue)
                }
            }
            .frame(maxHeight: 52)
        } header: {
            Text("Compte")
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.subheadline)
                .headerProminence(.increased)
                .padding(.top, 20)
        }
    }
}

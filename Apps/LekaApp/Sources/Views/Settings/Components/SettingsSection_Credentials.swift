// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SettingsSection_Credentials: View {
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        Section {
            Group {
                LabeledContent {
                    Text(self.company.currentCompany.mail)
                        // TODO: (@ui/ux) - Design System - replace with Leka font
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
                } label: {
                    Text("Adresse mail du compte")
                        .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
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
                .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                .headerProminence(.increased)
                .padding(.top, 20)
        }
    }
}

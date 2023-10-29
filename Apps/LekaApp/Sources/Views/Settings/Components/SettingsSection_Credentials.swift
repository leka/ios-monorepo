// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
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
                    Text(company.currentCompany.mail)
                        .font(metrics.reg14)
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
                .font(metrics.reg15)
                .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                .headerProminence(.increased)
                .padding(.top, 20)
        }
    }
}

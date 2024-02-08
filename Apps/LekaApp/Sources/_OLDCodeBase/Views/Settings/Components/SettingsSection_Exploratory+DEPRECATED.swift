// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SettingsSection_ExploratoryDeprecated: View {
    @EnvironmentObject var settings: SettingsViewModelDeprecated
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        Section {
            LabeledContent {
                Toggle("Mode exploratoire", isOn: self.$settings.exploratoryModeIsOn)
                    .toggleStyle(SwitchToggleStyle(tint: DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor))
                    .labelsHidden()
            } label: {
                Text("Le mode exploratoire vous permet de découvrir les contenus sans enregistrer l'utilisation")
                    .font(.footnote)
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
                    .frame(maxWidth: 300)
            }
            .frame(maxHeight: 52)
        } header: {
            HStack {
                Image(systemName: "binoculars.fill")
                Text("Mode exploratoire")
            }
            .font(.subheadline)
            .headerProminence(.increased)
        }
    }
}

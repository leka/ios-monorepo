// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SettingsSection_Exploratory: View {

    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        Section {
            LabeledContent {
                Toggle("Mode exploratoire", isOn: $settings.exploratoryModeIsOn)
                    .toggleStyle(SwitchToggleStyle(tint: DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor))
                    .labelsHidden()
            } label: {
                Text("Le mode exploratoire vous permet de découvrir les contenus sans enregistrer l'utilisation")
                    .font(metrics.reg13)
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
                    .frame(maxWidth: 300)
            }
            .frame(maxHeight: 52)
        } header: {
            HStack {
                Image(systemName: "binoculars.fill")
                Text("Mode exploratoire")
            }
            .font(metrics.reg15)
            .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
            .headerProminence(.increased)
        }
    }
}

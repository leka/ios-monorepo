// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - SettingsViewDeprecated

struct SettingsViewDeprecated: View {
    @EnvironmentObject var settings: SettingsViewModelDeprecated
    @EnvironmentObject var metrics: UIMetrics
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                DesignKitAsset.Colors.lekaLightGray.swiftUIColor.ignoresSafeArea()

                Form {
                    Group {
                        SettingsSection_Credentials()
                        SettingsSection_Exploratory()
                        SettingsSection_Profiles()
                        SettingsSection_Account()
                    }
                    .padding(.horizontal, 20)
                }
                .scrollDisabled(true)
                .padding(.horizontal, 10)
                .formStyle(.grouped)
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.headline)
            }
            .interactiveDismissDisabled()
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 4) {
                        Text("Réglages")
                        if self.settings.companyIsConnected, self.settings.exploratoryModeIsOn {
                            Image(systemName: "binoculars.fill")
                        }
                    }
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.headline)
                    .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            self.dismiss()
                        },
                        label: {
                            Text("Fermer")
                                .foregroundColor(.white)
                        }
                    )
                }
            }
        }
    }
}

// MARK: - SettingsView_Previews

struct SettingsView_Previews: PreviewProvider {
    @State static var open: Bool = true

    static var previews: some View {
        DesignKitAsset.Colors.lekaLightBlue.swiftUIColor
            .ignoresSafeArea()
            .sheet(isPresented: $open) {
                SettingsViewDeprecated()
                    .environmentObject(SettingsViewModelDeprecated())
                    .environmentObject(UIMetrics())
            }
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

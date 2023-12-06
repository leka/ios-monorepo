// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsViewModel
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
                .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                .font(metrics.reg17)
            }
            .interactiveDismissDisabled()
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 4) {
                        Text("Réglages")
                        if settings.companyIsConnected, settings.exploratoryModeIsOn {
                            Image(systemName: "binoculars.fill")
                        }
                    }
                    .font(metrics.semi17)
                    .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            dismiss()
                        },
                        label: {
                            Text("Fermer")
                                .foregroundColor(.white)
                        })
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var open: Bool = true

    static var previews: some View {
        DesignKitAsset.Colors.lekaLightBlue.swiftUIColor
            .ignoresSafeArea()
            .sheet(isPresented: $open) {
                SettingsView()
                    .environmentObject(SettingsViewModel())
                    .environmentObject(UIMetrics())
            }
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
